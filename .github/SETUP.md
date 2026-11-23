# GitHub setup

1. Create the public repository `vhdl-cpu` under the owner's GitHub account.
2. Upload the initial scaffold to `main` before enabling protection.
3. Enable GitHub Actions and allow the workflow to complete on `main`.
4. Import `.github/main-ruleset.json` in Settings > Rules > Rulesets.
   Confirm it is active, targets `main`, and requires `Branch policy`,
   `Source hygiene`, and `VHDL formatting` from GitHub Actions. Confirm
   that `atlas976` has bypass permission for pull requests only.
5. In Settings > General, allow squash merging only. Disable merge commits
   and rebase merging. Keep automatic branch deletion disabled if reusing branches.
6. Invite the other three people as collaborators with write access when their
   usernames are available. Public visibility alone does not grant push or review rights.
7. Verify with a PR that direct pushes are rejected and that collaborators
   need passing checks and an approval to merge.

The ruleset requires branches to be current with `main`, dismisses stale
approvals, requires resolved conversations, blocks force pushes and deletion,
and requires linear history. The owner may merge a PR with failed checks or
without approval and must still use a PR.

The workflow runs checks for every PR and uses read-only repository permissions.
