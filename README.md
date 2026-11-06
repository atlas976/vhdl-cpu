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

## Checks

On Windows, use Vivado for development. Optional local checks require Python 3,
Git, and GHDL on `PATH`. From PowerShell in the repository directory:

```powershell
py -3 scripts/check.py lint
py -3 scripts/check.py syntax
```

On Linux or macOS, use `python3` instead of `py -3`.
GitHub Actions runs these portable source checks on Linux; contributors do not
need Linux or GHDL to work in Vivado on Windows. `.gitattributes` keeps tracked
text files in LF format across platforms.

CI runs on every PR targeting `main`, including draft PRs, and on pushes to `main`.
It checks branch naming, basic source hygiene, disallowed arithmetic packages,
and VHDL syntax. It does not run simulations, synthesis, or timing analysis.
CI explicitly reports when there are no VHDL files.

