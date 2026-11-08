# vhdl-cpu

VHDL lecture assignments for a team of four, using Xilinx Vivado on Windows.

| Directory | Assignment |
| --- | --- |
| `memory-module/` | Memory model |
| `riscv-functional-behavioral-cpu/` | Functional/behavioral RISC-V CPU |
| `riscv-rtl-cpu/` | RTL RISC-V CPU |

Each assignment has `src/` for design files and `tb/` for testbenches.
Assignment specifications and implementations will be added later.

## Tools and language

CI uses GHDL with VHDL-2008 (`--std=08`) for syntax checking.
Vivado release is the `2019.1` version.
Set VHDL source files to VHDL 2008 in Vivado when using that standard.

## Contribution rules

- Work on your own branch: `<github-username>/<task>`, for example
  `atlas976/memory-interface`. Use lowercase kebab-case for the task.
- Open PRs against `main`. Direct pushes to `main` are forbidden.
- A PR needs one approval from another collaborator, passing required CI,
  and resolved review conversations. New commits dismiss previous approvals.
- Keep PRs focused. Explain the change and how you checked it.
- Squash merge after requirements pass. Update from `main` before starting work.
- Write code, comments, documentation, and commit messages in English.
- Use four spaces, UTF-8, LF endings, and a final newline. No trailing whitespace.
- Use `.vhd` or `.vhdl` for VHDL sources. Keep identifiers descriptive and consistent.
- Use `ieee.numeric_std` for arithmetic; do not use `std_logic_arith`,
  `std_logic_signed`, or `std_logic_unsigned`.
- Commit source files, constraints, and reproducible project Tcl scripts.
  Keep generated Vivado output and credentials out of Git.

Branch ownership is a team rule. CI checks the PR author's username prefix;
it does not prevent a collaborator from pushing to another person's branch.

## VHDL formatting

Use [VHDL Style Guide (VSG)](https://vhdl-style-guide.readthedocs.io/) with the
shared `vsg.yaml` configuration. It uses VSG's default formatting, with
four-space indentation and LF line endings to match `.editorconfig`.
The configuration allows signal/variable initialization, optional process
labels, both component and direct entity instantiations, and optional
architecture selection in direct instantiations. These are design choices
rather than formatting errors. The commands below automatically select this
configuration and prefer VSG from the repository's `.venv`, with a fallback
to `vsg` on `PATH`.

The formatter version is pinned in `requirements-dev.txt` so contributors use
the same rules. From PowerShell in the repository directory, install it once
in a local virtual environment:

```powershell
py -3 -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements-dev.txt
```

No environment activation or PowerShell execution-policy change is needed.
Format all existing tracked and untracked VHDL files, excluding ignored files:

```powershell
py -3 scripts/check.py format
```

Check formatting without changing any files (a nonzero exit code means that
violations remain or the formatter failed):

```powershell
py -3 scripts/check.py format-check
```

To format or check only specific files, append their paths. Paths are relative
to your current directory; quote paths that contain spaces:

```powershell
py -3 scripts/check.py format memory-module/atlas976-memory-module/RAM4096x12.vhd
py -3 scripts/check.py format-check memory-module/atlas976-memory-module/RAM4096x12.vhd
```

Review the diff after formatting. Rules that cannot be fixed automatically
must be addressed manually.

On Linux or macOS, create the environment with `python3 -m venv .venv` and
install with `.venv/bin/python -m pip install -r requirements-dev.txt`.
Use `python3 scripts/check.py format` and `python3 scripts/check.py format-check`.

Formatting can be applied locally; CI checks the same shared VSG rules without
modifying files. It does not replace the checks below.
The hygiene check also covers non-VHDL files and prohibited arithmetic packages.
GHDL checks VHDL syntax and name resolution; formatting does not guarantee
that those checks pass.

## Checks

On Windows, use Vivado for development. Optional local checks require Python 3,
Git, and GHDL on `PATH`. From PowerShell in the repository directory:

```powershell
py -3 scripts/check.py lint
py -3 scripts/check.py syntax
```

Recommended local workflow after saving your code:

```powershell
py -3 scripts/check.py format
py -3 scripts/check.py format-check
py -3 scripts/check.py lint
py -3 scripts/check.py syntax
```

Resolve failures before committing. Formatting may leave non-fixable style
violations that need manual changes. Review the diff after automatic fixes.

Both checks read the current saved files on disk, including untracked files.
Neither `git add` nor a commit is required. Ignored untracked files (for example,
`.venv/` and generated Vivado output) and deleted files are skipped. Tracked
files remain included even if they match an ignore rule.

The syntax check analyzes all VHDL files into a temporary `work` library using
`ghdl -a --std=08`. It retries files with unresolved dependencies after other
files have been analyzed, so filenames do not need to be in compilation order.
If no further file can be analyzed, the remaining diagnostics are reported and
the check fails. Missing sources and actual VHDL errors still need to be fixed.
All sources currently use the same `work` library; vendor-specific libraries
must be supplied separately if needed. No simulation or synthesis is run.

Regression tests cover file discovery, dependency handling, and the formatter
commands. Use Python 3 and Git, with GHDL on `PATH` and VSG installed as above
to run all tests (tool-specific tests are skipped if the tool is unavailable):

```powershell
py -3 -m unittest discover -s scripts -p "test_*.py" -v
```

On Linux or macOS, use `python3` instead of `py -3`.
GitHub Actions runs these portable source checks on Linux; contributors do not
need Linux or GHDL to work in Vivado on Windows. `.gitattributes` keeps tracked
text files in LF format across platforms.

## GitHub Actions

CI runs on every PR targeting `main`, including draft PRs, on pushes to `main`,
and when manually dispatched. Further pushes to a branch with an open PR
targeting `main` automatically rerun CI. A push to another branch without
such a PR does not automatically start CI.

| Check | What it verifies |
| --- | --- |
| Branch policy | PR author prefix and lowercase kebab-case task name; PRs only |
| Source hygiene | Encoding, whitespace, final newline, and prohibited arithmetic packages |
| VHDL formatting | Shared `vsg.yaml` rules with the pinned VSG version; no automatic fixes |
| Check script tests | File discovery, dependency handling, error detection, and formatter commands |
| VHDL syntax | GHDL analysis using VHDL-2008 |

The regression-test job installs both GHDL and VSG so all tool-specific tests
can run. CI does not simulate the CPU or memory testbench, perform synthesis,
or run timing analysis. Checks explicitly report when there are no VHDL files.

To run CI manually, open **Actions > CI > Run workflow**, select the branch,
and click **Run workflow**. The selected branch must contain the workflow and
its check scripts, formatter configuration, and requirements file.

GitHub shows the manual-run button only after the `workflow_dispatch` trigger
is present on the default branch (`main`). Until this workflow update is merged
into `main`, open a draft PR targeting `main` to test the updated workflow on
your feature branch. The PR does not need to be merged for its checks to run.

