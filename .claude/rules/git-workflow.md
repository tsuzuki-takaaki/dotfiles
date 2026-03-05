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

 ## Pre-Commit Dependency Failures

 Linters/formatters may run on pre-commit. In a new worktree, dependencies may not be installed, causing commits to fail.

 If a commit fails due to missing dependencies, identify the required package manager and install dependencies in the appropriate directory (e.g., `npm
 install`, `uv sync`, `pip install`, etc.).

 ## Environment Variables

 If the worktree is missing required environment variables (e.g., `.env` file):

 - Copy the `.env` file (or other env config) from the base repository directory into the new worktree before starting work.
 - Example: `cp ../{repository-name}/.env .`
