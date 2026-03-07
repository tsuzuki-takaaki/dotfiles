# Git Workflow Rules

When working on a task, always follow this git workflow.

## Branching Workflow

1. Checkout `main` branch and pull the latest changes: `git checkout main && git pull`
2. Create a new worktree in the parent directory using `git worktree add`
- Worktree directory name: `{repository-name}-{branch-name}`
3. Name the branch based on the issue/prompt content

## Commit Rules

- Write commit messages in English, starting with an uppercase letter (e.g., `Add temperature alert`)
- Always include a Co-Authored-By trailer for Claude:
Co-Authored-By: Claude Sonnet 4.6 noreply@anthropic.com

## Commit Granularity

Commits must be divided by responsibility. Do not mix unrelated changes in a single commit.

### Key principles

- **Separate refactoring from feature changes**: Never combine a refactoring (renaming, restructuring) with a feature addition or bug fix in the same commit.
- **Separate changes by responsibility**: Do not bundle multiple independent changes (e.g., changes to multiple endpoints) into one commit. Each logical unit of change should be its own commit.
- **Separate chore/fix commits**: If a linter or formatter flags an issue that was pre-existing (not caused by the current change), fix it in a separate commit from the main change. Do not mix cleanup with functional changes.

### Examples

| Bad | Good |
|-----|------|
| Refactor UserService and add new login endpoint | Two commits: "Refactor UserService" + "Add login endpoint" |
| Update /users and /posts endpoints | Two commits: one per endpoint |
| Fix lint error + implement feature | Two commits: "Fix lint error" + "Implement feature" |

## Pre-Commit Dependency Failures

Linters/formatters may run on pre-commit. In a new worktree, dependencies may not be installed, causing commits to fail.

If a commit fails due to missing dependencies, identify the required package manager and install dependencies in the appropriate directory (e.g., `npm
install`, `uv sync`, `pip install`, etc.).

## Environment Variables

If the worktree is missing required environment variables (e.g., `.env` file):

- Copy the `.env` file (or other env config) from the base repository directory into the new worktree before starting work.
- Example: `cp ../{repository-name}/.env .`
