# Harness Review

Analyze today's failure log, then produce two outputs:
1. Rule improvements on Claude's side → apply to `rules/`
2. Information gap insights on the user's side → write to `~/.claude/harness/insights/YYYY-MM-DD.md`

## Steps

1. Read `~/.claude/harness/failures/YYYY-MM-DD.md` (today's date)
   - If the file does not exist, report that no failures were logged today and stop

2. For each failure, determine responsibility:
   - **Claude's fault**: insufficient rules, wrong assumptions, missing permissions
   - **Information gap**: Claude could have handled it correctly if given specific context upfront

3. Produce Claude-side improvements:
   - **Permission failure** → propose adding the command/tool to `permissions.allow` in `settings.json`
   - **Question / Correction failure (Claude's fault)** → propose adding a rule to `rules/` that prevents the same issue
   - Present proposals to the user and apply approved ones

4. Produce user-side insights and write to `~/.claude/harness/insights/YYYY-MM-DD.md`:

```
## <failure summary>

- **Missing information**: What context or detail was absent
- **How it would have helped**: How Claude's behavior would have differed with that information
- **Suggestion**: What to include in future prompts (e.g., "mention the target branch", "clarify scope upfront")
```

   Write the file even if there are no user-side insights (note "No user-side gaps identified today").
