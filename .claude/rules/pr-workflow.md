# PR Workflow Rules

After implementation is complete, create a pull request.

## PR Creation

Use the GitHub CLI to create a PR:

```
gh pr create --title "<title>" --body "<body>" --assignee tsuzuki-takaaki
```

- Do NOT specify `--reviewer`
- Do NOT use `--draft` (open PR)

## PR Title

- Always written in **English**
- Follow the same style as commit messages (start with uppercase verb)

## PR Body

- Written in **Japanese**
- First, check if a PR template exists in the repository (e.g., `.github/PULL_REQUEST_TEMPLATE.md`)
  - If a template exists, read it and follow its structure
  - If no template exists, use this minimal structure:

```
## What
<!-- 何を変更したか -->

## Why
<!-- なぜ変更したか -->

## How
<!-- どのように実装したか -->
```
