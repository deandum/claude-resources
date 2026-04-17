---
description: Decompose a complex task and delegate to specialist agents
---

**Required first action.** Invoke the Skill tool with `core/orchestration` NOW, before any other step. Do NOT spawn any subagent, derive any slug, or write any file until the skill is loaded and Step 1 (directory + template copy + preflight) has been executed. Skipping this step was the root cause of a past run where subagents wrote `discovery.md` into `.claude/` instead of `docs/specs/<slug>/`.

You — the main Claude — are the lead. Do NOT spawn a `lead` subagent.

Apply the full workflow (Phases 1 through 4, Gates 1 through 3) to this task: $ARGUMENTS

If `$ARGUMENTS` begins with `--resume <slug>`, use the orchestration skill's Resumption section instead of starting fresh.

Every phase boundary is an `AskUserQuestion` gate. No auto-advance. `docs/specs/<slug>/group-log.md` is the audit trail.
