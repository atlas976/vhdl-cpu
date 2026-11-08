"""Repository checks. Run from any directory with Python 3."""

import argparse
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
TEXT_SUFFIXES = {".vhd", ".vhdl", ".md", ".py", ".yml", ".yaml", ".json", ".tcl", ".xdc"}


def repository_files():
    result = subprocess.run(
        ["git", "ls-files", "--cached", "--others", "--exclude-standard", "-z"],
        cwd=ROOT, check=True, capture_output=True
    )
    names = sorted({os.fsdecode(name) for name in result.stdout.split(b"\0") if name})
    return [ROOT / name for name in names if (ROOT / name).is_file()]


def check_branch(branch, author):
    if not branch and not author:
        print("No PR context; branch policy does not apply.")
        return 0
    pattern = re.escape(author) + r"/[a-z0-9]+(?:-[a-z0-9]+)*"
    if not author or not re.fullmatch(pattern, branch, flags=re.IGNORECASE):
        print(f"Invalid branch: {branch!r}; expected {author}/<task>.")
        return 1
    task = branch.split("/", 1)[1]
    if task != task.lower():
        print("Task names must use lowercase kebab-case.")
        return 1
    print(f"Branch policy passed: {branch}")
    return 0


def lint(files):
    errors = []
    for path in files:
        if path.name.startswith(".env"):
            errors.append(f"{path.relative_to(ROOT)}: credential files must not be tracked")
            continue
        if path.suffix not in TEXT_SUFFIXES and path.name not in {".gitignore", ".editorconfig"}:
            continue
        try:
            text = path.read_bytes().decode("utf-8")
        except UnicodeDecodeError:
            errors.append(f"{path.relative_to(ROOT)}: expected UTF-8")
            continue
        name = path.relative_to(ROOT)
        if text and not text.endswith("\n"):
            errors.append(f"{name}: missing final newline")
        for number, line in enumerate(text.splitlines(keepends=True), 1):
            body = line.rstrip("\r\n")
            if "\r" in line or "\t" in body or body != body.rstrip():
                errors.append(f"{name}:{number}: CR, tab, or trailing whitespace")
        if path.suffix.lower() in {".vhd", ".vhdl"}:
            code = re.sub(r"--[^\n]*", "", text)
            if re.search(r"\b(?:std_logic_arith|std_logic_signed|std_logic_unsigned)\b", code, re.I):
                errors.append(f"{name}: use ieee.numeric_std for arithmetic")
    for error in errors:
        print(error)
    print(f"Source hygiene: {len(errors)} error(s).")
    return bool(errors)


def format_vhdl(files, fix=False):
    sources = [p for p in files if p.suffix.lower() in {".vhd", ".vhdl"}]
    if not sources:
        print("No VHDL files yet; formatting has no inputs.")
        return 0
    local = ROOT / ".venv" / ("Scripts/vsg.exe" if os.name == "nt" else "bin/vsg")
    executable = str(local) if local.is_file() else shutil.which("vsg")
    if not executable:
        print("VSG is required. Install requirements-dev.txt in .venv (see README).")
        return 1
    command = [executable, "-c", str(ROOT / "vsg.yaml")]
    if fix:
        command.append("--fix")
    command.extend(["-f", *map(str, sources)])
    return subprocess.run(command, cwd=ROOT).returncode


def syntax(files):
    sources = [p for p in files if p.suffix.lower() in {".vhd", ".vhdl"}]
    if not sources:
        print("No VHDL files yet; syntax checking has no inputs.")
        return 0
    if not shutil.which("ghdl"):
        print("GHDL is required for syntax checking.")
        return 1
    with tempfile.TemporaryDirectory(prefix="vhdl-syntax-") as work:
        pending = sources
        while pending:
            failed = []
            diagnostics = []
            for source in pending:
                result = subprocess.run(
                    ["ghdl", "-a", "--std=08", str(source)],
                    cwd=work, capture_output=True, text=True,
                    encoding="utf-8", errors="replace"
                )
                output = result.stdout + result.stderr
                if result.returncode:
                    failed.append(source)
                    diagnostics.append(output)
                else:
                    print(f"Checked {source.relative_to(ROOT)}", flush=True)
                    if output:
                        print(output, end="")
            if len(failed) == len(pending):
                print("VHDL analysis failed; fix the errors or missing dependencies below.")
                for output in diagnostics:
                    print(output, end="")
                return 1
            # Successful analyses populate WORK for files with dependencies.
            # Retry deferred files only while at least one file makes progress.
            pending = failed
    return 0


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("check", choices=["branch", "lint", "syntax", "format", "format-check"])
    parser.add_argument("files", nargs="*", type=Path, help="VHDL files for format/format-check; default: all")
    args = parser.parse_args()
    if args.files and args.check not in {"format", "format-check"}:
        parser.error("File arguments are only supported for format and format-check.")
    if args.check == "branch":
        raise SystemExit(check_branch(os.getenv("PR_BRANCH", ""), os.getenv("PR_AUTHOR", "")))
    if args.files:
        files = [path.resolve() for path in args.files]
        for path in files:
            if not path.is_file() or path.suffix.lower() not in {".vhd", ".vhdl"}:
                parser.error(f"Not an existing VHDL file: {path}")
    else:
        files = repository_files()
    if args.check in {"format", "format-check"}:
        raise SystemExit(format_vhdl(files, fix=args.check == "format"))
    raise SystemExit(lint(files) if args.check == "lint" else syntax(files))
