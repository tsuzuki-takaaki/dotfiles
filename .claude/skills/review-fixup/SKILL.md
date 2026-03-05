 ---
 name: review-fixup
 description: |
   Review PR comments and stack fixup commits to address them.
   Does NOT autosquash — only creates fixup commits.

   Use when:
   - Starting to address review comments on a PR
   - Invoked with /review-fixup
 ---

 ## Steps

 1. Confirm the current branch is the target PR branch.

 2. Fetch review comments:

    gh pr view --json reviews,reviewComments --jq '{reviews: .reviews, comments: .reviewComments}'

 3. List unresolved comments (CHANGES_REQUESTED or unresolved threads).

 4. For each comment:
 a. Locate the file and line referenced in the comment
 b. Fix the code according to the comment
 c. Identify the original commit to fix:
    ```
    git log --oneline
    ```
 d. Create a fixup commit:
    ```
    git add <modified files>
    git commit --fixup=<target commit SHA>
    ```

 5. After addressing all comments, show the commit log for confirmation:

    git log --oneline

 ## Notes

 - `git commit --fixup` creates a commit with the `fixup! <original message>` prefix
 - Do NOT run autosquash (`git rebase -i --autosquash`) — that is out of scope
 - Do NOT push — stop after stacking fixup commits locally
 - If the original commit cannot be identified, use a regular commit: `git commit -m "Address review: ..."`
