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


def tracked_files():
    result = subprocess.run(
        ["git", "ls-files", "-z"], cwd=ROOT, check=True, capture_output=True
    )
    return [ROOT / os.fsdecode(name) for name in result.stdout.split(b"\0") if name]


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


def syntax(files):
    sources = [p for p in files if p.suffix.lower() in {".vhd", ".vhdl"}]
    if not sources:
        print("No VHDL files yet; syntax checking has no inputs.")
        return 0
    if not shutil.which("ghdl"):
        print("GHDL is required for syntax checking.")
        return 1
    failed = False
    with tempfile.TemporaryDirectory(prefix="vhdl-syntax-") as work:
        for source in sources:
            print(f"Checking {source.relative_to(ROOT)}", flush=True)
            result = subprocess.run(["ghdl", "-s", "--std=08", str(source)], cwd=work)
            failed |= result.returncode != 0
    return failed


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("check", choices=["branch", "lint", "syntax"])
    args = parser.parse_args()
    if args.check == "branch":
        raise SystemExit(check_branch(os.getenv("PR_BRANCH", ""), os.getenv("PR_AUTHOR", "")))
    files = tracked_files()
    raise SystemExit(lint(files) if args.check == "lint" else syntax(files))
