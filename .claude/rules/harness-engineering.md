# Harness Engineering

A practice for continuously improving Claude Code's autonomy.
Record situations that block progress or lead in the wrong direction as "failures", then convert them into rules at the end of each day.

> Inspired by Mitchell Hashimoto's AI adoption journey: https://mitchellh.com/writing/my-ai-adoption-journey

## Failure Categories

| Category | Condition |
|----------|-----------|
| **Permission failure** | A tool use required explicit yes/no from the user, blocking progress |
| **Question failure** | Used `AskUserQuestion` after task start (excluding initial requirement clarification) |
| **Correction failure** | Received a course correction request from the user (wrong direction, implementation, or interpretation) |

## Logging Failures

**Logging is mandatory. It is always the very first action — before composing a response, before any tool call.**

- **Permission failure**: Write to the log file before the tool call that requires permission
- **Question failure**: Write to the log file before calling `AskUserQuestion`
- **Correction failure**: Write to the log file as the absolute first action upon receiving a correction — before writing any response text, before any tool use

Do not skip. Do not defer. Even minor corrections must be logged.

### In Plan Mode

Plan mode restricts file writes to the plan file only. If a failure occurs during plan mode:

1. Record the failure entry in the plan file as a temporary note
2. You may exit plan mode early ONLY for the purpose of writing the failure log.
   Do not use this exception for any other reason.
3. Immediately after exiting plan mode, write it to the failure log as the very first action

**Log file path**: `~/.claude/harness/failures/YYYY-MM-DD.md`

**Format**:

```
## Permission|Question|Correction: <one-line summary>

- **Context**: What was being attempted
- **Cause**: Why progress was blocked / what was wrong
- **Action**: What was asked of the user / what correction was requested
```

Create the file if it does not exist.

## Daily Review

At the end of each day, run `/harness-review` to analyze failure patterns and reflect them into rules.
