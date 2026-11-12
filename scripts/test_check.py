"""Regression tests for repository discovery and real GHDL analysis."""

from contextlib import redirect_stdout
import io
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

import check

PROJECT_ROOT = Path(check.__file__).resolve().parents[1]
LOCAL_VSG = PROJECT_ROOT / ".venv" / ("Scripts/vsg.exe" if os.name == "nt" else "bin/vsg")
VSG = str(LOCAL_VSG) if LOCAL_VSG.is_file() else shutil.which("vsg")


class CheckTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="vhdl-check-test-")
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        patcher = patch.object(check, "ROOT", self.root)
        patcher.start()
        self.addCleanup(patcher.stop)

    def write(self, name, text):
        path = self.root / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(text.encode("utf-8"))
        return path

    def git(self, *args):
        subprocess.run(["git", *args], cwd=self.root, check=True, capture_output=True)

    def test_discovery_without_commits(self):
        self.git("init", "-q")
        self.write(".gitignore", "ignored.vhd\n.venv/\n")
        tracked = self.write("tracked.vhd", "-- staged\n")
        deleted = self.write("deleted.vhd", "-- deleted locally\n")
        self.git("add", "tracked.vhd", "deleted.vhd")
        deleted.unlink()
        self.write("tracked.vhd", "-- current unstaged content\n")
        new = self.write("new file.vhd", "-- untracked\n")
        self.write("ignored.vhd", "invalid ignored VHDL\n")
        self.write(".venv/generated.vhd", "invalid generated VHDL\n")
        # An ignore rule must not hide an already tracked source.
        self.write(".gitignore", "ignored.vhd\n.venv/\ntracked.vhd\n")
        self.assertEqual(
            check.repository_files(), [self.root / ".gitignore", new, tracked]
        )
        with redirect_stdout(io.StringIO()):
            self.assertEqual(check.lint(check.repository_files()), 0)
        self.write("new file.vhd", "-- untracked with trailing whitespace \n")
        with redirect_stdout(io.StringIO()) as output:
            self.assertEqual(check.lint(check.repository_files()), 1)
        self.assertIn("new file.vhd:1", output.getvalue())

    @unittest.skipUnless(VSG, "VSG is required")
    def test_formatter_cli_round_trip(self):
        self.git("init", "-q")
        self.write(".gitignore", "ignored.vhd\n")
        self.write("ignored.vhd", "invalid ignored VHDL\n")
        notes = self.write("notes.txt", "Do not format this.  \n")
        source = self.write(
            "new design.vhd",
            "ENTITY demo IS\r\nEND ENTITY;\r\n"
            "ARCHITECTURE rtl OF demo IS\r\nBEGIN\r\n"
            "PROCESS\r\nBEGIN\r\nWAIT;\r\nEND PROCESS;\r\nEND ARCHITECTURE;\r\n"
        )
        script = self.root / "scripts/check.py"
        script.parent.mkdir()
        shutil.copyfile(PROJECT_ROOT / "scripts/check.py", script)
        shutil.copyfile(PROJECT_ROOT / "vsg.yaml", self.root / "vsg.yaml")
        env = os.environ.copy()
        env["PATH"] = str(Path(VSG).parent) + os.pathsep + env.get("PATH", "")

        def run(*args):
            return subprocess.run(
                [sys.executable, str(script), *args], cwd=self.root.parent,
                env=env, capture_output=True, text=True
            )

        original = source.read_bytes()
        result = run("format-check", str(source))
        self.assertNotEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(source.read_bytes(), original)
        result = run("format")
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        formatted = source.read_bytes()
        self.assertNotEqual(formatted, original)
        self.assertNotIn(b"\r", formatted)
        self.assertIn(b"    process", formatted)
        for args in [("format-check",), ("format", str(source))]:
            result = run(*args)
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            self.assertEqual(source.read_bytes(), formatted)
        self.assertEqual(notes.read_bytes(), b"Do not format this.  \n")

    @unittest.skipUnless(shutil.which("ghdl"), "GHDL is required")
    def test_dependencies_in_reverse_filename_order(self):
        self.git("init", "-q")
        self.write(
            "a_top.vhd",
            "entity top is end entity;\n"
            "architecture rtl of top is begin\n"
            "    u_child : entity work.child(rtl);\n"
            "end architecture;\n"
        )
        self.write(
            "m_child.vhd",
            "use work.constants.all;\n"
            "entity child is end entity;\n"
            "architecture rtl of child is\n"
            "    constant width : positive := width_c;\n"
            "begin end architecture;\n"
        )
        self.write(
            "z_constants.vhd",
            "package constants is\n"
            "    constant width_c : positive := 8;\n"
            "end package;\n"
        )
        with redirect_stdout(io.StringIO()):
            self.assertEqual(check.syntax(check.repository_files()), 0)
        self.assertEqual(list(self.root.glob("*.cf")), [])

    @unittest.skipUnless(shutil.which("ghdl"), "GHDL is required")
    def test_semantic_error_is_not_hidden(self):
        source = self.write(
            "bad.vhd",
            "entity bad is end entity;\n"
            "architecture rtl of bad is\n"
            "    signal value : integer := true;\n"
            "begin end architecture;\n"
        )
        with redirect_stdout(io.StringIO()) as output:
            self.assertEqual(check.syntax([source]), 1)
        self.assertIn("bad.vhd", output.getvalue())

    @unittest.skipUnless(shutil.which("ghdl"), "GHDL is required")
    def test_missing_dependency_fails(self):
        source = self.write(
            "top.vhd",
            "entity top is end entity;\n"
            "architecture rtl of top is begin\n"
            "    u_missing : entity work.missing(rtl);\n"
            "end architecture;\n"
        )
        with redirect_stdout(io.StringIO()) as output:
            self.assertEqual(check.syntax([source]), 1)
        self.assertIn("missing", output.getvalue())


if __name__ == "__main__":
    unittest.main()
