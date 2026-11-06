# GitHub setup

1. Create the public repository `vhdl-cpu` under the owner's GitHub account.
2. Upload the initial scaffold to `main` before enabling protection.
3. Enable GitHub Actions and allow the workflow to complete on `main`.
4. Import `.github/main-ruleset.json` in Settings > Rules > Rulesets.
   Confirm it is active, targets `main`, has no bypass actors, and requires
   `Branch policy`, `Source hygiene`, and `VHDL syntax` from GitHub Actions.
5. In Settings > General, allow squash merging only. Disable merge commits
   and rebase merging. Keep automatic branch deletion disabled if reusing branches.
6. Invite the other three people as collaborators with write access when their
   usernames are available. Public visibility alone does not grant push or review rights.
7. Verify with a PR that direct pushes are rejected, CI is required, and a
   second collaborator must approve before merging. Do not merge a deliberately
   failing check to test the rules.

The ruleset requires branches to be current with `main`, dismisses stale
approvals, requires resolved conversations, blocks force pushes and deletion,
and requires linear history. No account, including the owner, has a configured
bypass. An administrator can still edit or disable repository rules.

Required checks apply to all PRs; there are no path filters that skip them.
The workflow uses read-only repository permissions and never uses
`pull_request_target` to execute contributor code.
