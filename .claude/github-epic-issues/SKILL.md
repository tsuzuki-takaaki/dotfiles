---
name: github-epic-issues
description: Break a large piece of work (e.g. a design doc, a migration, a multi-phase feature) into a parent GitHub issue plus a chain of child issues, drafted conversationally one at a time, linked with native parent/blocked-by relations, and formatted to Chambrix's Japanese style conventions. Use when the user wants to turn an agreed design/plan into a tracked set of implementation issues, or says things like "親 issue を作ろう" / "子 issue を作っていこう" / "一つずつ作っていこう".
---

# GitHub Epic Issues

Turn an already-agreed design or plan into a parent issue plus a chain of child
issues on GitHub, using `gh` + the GitHub GraphQL API. This captures a workflow
that worked well when breaking down issue #859 (Chambrix's MQTT migration) into
14 child issues.

## Overall flow

1. Create the **parent issue** first, with a `TODO` checklist enumerating every
   planned child (plain text at this point, no links yet — the children don't
   exist)
2. Create child issues **one at a time**, conversationally: draft the body,
   show it to the user, wait for confirmation, only then run `gh issue create`
3. After each child is created, immediately:
   - Set the **parent relation** (native GitHub sub-issue, not just a checklist
     mention)
   - Set **`blocked by`** relations for every issue it depends on (never write
     "(依存)" as plain text — see [[feedback_github_issue_pr_references]])
   - Set the **assignee** to the user
   - Update the parent issue's TODO line to a link to the new child, replacing
     the plain-text placeholder
4. Decide creation **order by actual dependency**, not by the order items were
   listed in the parent's TODO. Ask "what needs to exist before this can be
   tested/built" — e.g. a broker must exist before a client that connects to
   it, even if the client was listed first.

Do all of this conversationally — draft, get a one-word "ok"/"yes" confirmation,
create, wire up relations, move to the next. Don't batch multiple child issues
into one turn; the user is reviewing each design decision as it's drafted.

## Parent issue

Follow `.github/ISSUE_TEMPLATE/default.md` (Why / What / TODO / Refs, all
sections in Japanese, per `.claude/rules/issue-creation.md`). The `Why` section
carries the overall motivation; `TODO` is the full checklist of children,
grouped by theme if useful (e.g. 基盤 / Edge→Relay / Relay→Edge / 後片付け).
Each TODO line starts as plain Japanese text — it gets replaced with a link
once that child issue exists (see step 4 above).

## Drafting a child issue

For each child, write Why / What / TODO / Refs and show it to the user as a
draft before creating anything. Reuse concrete facts already established in
the conversation (function names, file paths, prior decisions) rather than
re-deriving them. Keep `Refs` as one URL per bullet line — never comma-join
multiple issue links onto one line (it reads as a single broken link and is
inconsistent with every other issue).

## Japanese formatting: half-width/full-width spacing + verb-ending titles

Two style rules apply to **all** issue titles and body text (not just
GitHub — this applies to normal chat responses too):

1. Insert a half-width space at every boundary between a half-width run
   (ASCII letters/digits) and a full-width run (Japanese kana/kanji) — e.g.
   `Relay 側 MQTT 購読基盤` not `Relay側MQTT購読基盤`. Code spans
   (`` `...` ``) and URLs are exempt — never insert spaces inside them.
2. Titles end with a verb (`〜を新設する`, `〜を導入する`), not a noun
   (`〜の新設`). Converting a noun phrase to a verb phrase usually means
   changing the particle too (`の` → `を`).

Do not rely on typing these by hand — mistakes slip through repeatedly even
with care. Before every `gh issue create` / `gh issue edit --body-file`,
pipe the drafted body through this script (protects code spans and URLs,
then inserts spacing at every remaining half/full-width boundary):

```python
import re
import sys

FULL = r'[ぁ-ヺヽヾ一-鿿]'
HALF = r'[A-Za-z0-9]'
PH = r'(?:\x00\d+\x00)'

def protect(text):
    tokens = []
    def repl(m):
        tokens.append(m.group(0))
        return f"\x00{len(tokens)-1}\x00"
    text = re.sub(r'`[^`]*`', repl, text)
    text = re.sub(r'https?://\S+', repl, text)
    return text, tokens

def restore(text, tokens):
    def repl(m):
        return tokens[int(m.group(1))]
    return re.sub(r'\x00(\d+)\x00', repl, text)

def space_fix(text):
    protected, tokens = protect(text)
    for _ in range(2):
        protected = re.sub(f'({HALF}|{PH})({FULL})', r'\1 \2', protected)
        protected = re.sub(f'({FULL})({HALF}|{PH})', r'\1 \2', protected)
        protected = re.sub(f'({FULL})(\\()', r'\1 \2', protected)
        protected = re.sub(f'(\\))({FULL})', r'\1 \2', protected)
    return restore(protected, tokens)

for line in sys.stdin:
    print(space_fix(line), end='')
```

The script has one known gap: a protected placeholder (code span or URL)
directly followed by `(` does not get a space inserted (e.g.
`https://.../860(依存)` stays glued). Grep the output for `` `[^\s(]\(`` or
just eyeball the `Refs`/`What` sections after running it — this is the most
common leftover.

**Pitfalls actually hit while doing this:**

- Piping the script's output to the terminal for the user to review, then
  passing a *different, unfixed* file to `gh issue create`, ships the raw
  draft. Always write the fixed output to the file you're about to pass to
  `gh`, not just to stdout for display.
- Strip any `(叩き台)` / draft-label suffixes from headings before creating —
  they're for the chat draft only, never for the posted issue.
- Re-run the script on the parent issue's body too whenever a checklist line
  is edited by hand — hand-edited insertions (e.g. `の削除` immediately after
  a pasted URL) commonly reintroduce the same spacing gaps.

## Native GitHub relations, not text

Once an issue mentions "depends on" or "is part of", set it via the API —
never write "(依存)" as prose (see
[[feedback_github_issue_pr_references]]). `gh issue` has no subcommand for
either relation; use `gh api graphql` directly. Resolve issue numbers to
node IDs first:

```bash
gh api graphql -f query='
query {
  repository(owner: "OWNER", name: "REPO") {
    i100: issue(number: 100) { id }
    i101: issue(number: 101) { id }
  }
}'
```

**Parent / sub-issue** (shows in the GitHub UI's issue hierarchy, separate
from and complementary to the parent's checklist):

```bash
gh api graphql -f query='
mutation($issueId: ID!, $subIssueId: ID!) {
  addSubIssue(input: { issueId: $issueId, subIssueId: $subIssueId }) { issue { number } }
}' -f issueId="<parent node id>" -f subIssueId="<child node id>"
```

**Blocked by** (dependency graph, shown in the issue sidebar):

```bash
gh api graphql -f query='
mutation($issueId: ID!, $blockingIssueId: ID!) {
  addBlockedBy(input: { issueId: $issueId, blockingIssueId: $blockingIssueId }) { issue { number } }
}' -f issueId="<blocked issue node id>" -f blockingIssueId="<blocking issue node id>"
```

When setting several pairs in a loop, **write it in Python, not a bash loop
with an associative array + `set --`**. This repo's shell is zsh, where
unquoted parameter expansion does not word-split by default — `set -- $pair`
silently leaves `$2` empty instead of splitting `"100 101"` into two args.
A small Python script calling `subprocess.run(["gh", "api", "graphql", ...])`
per pair sidesteps this entirely and is what actually worked:

```python
import subprocess

IDS = {100: "...", 101: "..."}  # issue number -> node id
PAIRS = [(101, 100)]  # (blocked, blocker)

def gql(query, **vars):
    cmd = ["gh", "api", "graphql", "-f", f"query={query}"]
    for k, v in vars.items():
        cmd += ["-f", f"{k}={v}"]
    r = subprocess.run(cmd, capture_output=True, text=True)
    print(r.returncode, r.stdout.strip() or r.stderr.strip())

for blocked, blocker in PAIRS:
    gql("""
    mutation($issueId: ID!, $blockingIssueId: ID!) {
      addBlockedBy(input: { issueId: $issueId, blockingIssueId: $blockingIssueId }) { issue { number } }
    }
    """, issueId=IDS[blocked], blockingIssueId=IDS[blocker])
```

After relations are set, remove any now-redundant "(依存)" / "の依存元" text
from the `Refs` bullets — the relation itself carries that meaning; keep only
substantive context (e.g. *why* it's a dependency) if it adds something the
relation doesn't already say.

## Assignee

Set every issue (parent and children) to the user, even without being asked
explicitly each time:

```bash
gh issue edit <number> --add-assignee <username>
```

## After each child issue is fully wired up

1. Fetch the parent's current body, replace the matching plain-text TODO line
   with `- [ ] <child URL> <child title>`, write it back with
   `gh issue edit --body-file`
2. Note what was created/decided in project memory (issue numbers, key design
   choices, open questions deferred to a later child) so a future session can
   pick the chain back up without re-deriving it
