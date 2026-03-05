---
name: check-dependabot
description: |
  Review dependabot dependency update PRs assigned to tsuzuki-takaaki.
  Follow the flow: list PRs → check CI → review CHANGELOG → investigate issues.

  Use when:
  - Asked to review dependabot PRs
  - Need to determine whether a dependency update is safe to merge
---

## Steps

1. List all open dependabot PRs where `tsuzuki-takaaki` is a requested reviewer:

   ```
   gh pr list --author app/dependabot --reviewer tsuzuki-takaaki --state open
   ```

2. For each PR, check CI status:

   ```
   gh pr checks <PR_NUMBER>
   ```

## If all CI checks pass

Review the CHANGELOG (refer to the link in the dependabot commit message).

Check for:

- **Breaking changes** — especially important for major version bumps
- **Suspicious commits** — any code unrelated to the release mixed in
- **Impact on this repository** — whether any APIs or features in use have changed

Report the findings — summarize each PR with the review result (safe to merge / issues found). Do not approve the PR.

## If CI is failing

Inspect `git show` or the lock file diff (e.g. `Gemfile.lock`, `yarn.lock`) to check whether other packages were also upgraded.

### Other packages were also upgraded

Consider whether the target package can be updated independently:

- Adjust the dependabot configuration, or
- Run `bundle update <gem>` / `yarn upgrade <package>` to propose an isolated update

### Only the target package was upgraded

1. Retrieve and analyze the CI failure logs
2. Identify the root cause:
   - **A. Issue in this repository** — e.g. usage of a deprecated API
   - **B. Issue introduced by the package update** — e.g. a breaking change
3. Fix if possible; otherwise report the findings
