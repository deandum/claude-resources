---
description: Implement application code following established patterns
---

## Language Detection

Detect the project language from marker files:
- `go.mod` → lang=go, plugin=go-skills
- `package.json` + `angular.json` → lang=angular, plugin=angular-skills
- `package.json` (no angular) → lang=node, plugin=node-skills
- `Cargo.toml` → lang=rust, plugin=rust-skills
- `pyproject.toml` or `requirements.txt` → lang=python, plugin=python-skills

## Task

Determine if this is a CLI command task or application code:
- CLI commands, flags, config → spawn cli-builder agent (subagent_type: `{plugin}:{lang}-cli-builder`)
- All other code → spawn builder agent (subagent_type: `{plugin}:{lang}-builder`)

Pass this task to the agent: $ARGUMENTS

The agent has `core/error-handling` and `core/style` skills loaded,
plus language-specific skills auto-detected from the project.

Invoke relevant language skills based on the task:
- `{plugin}:{lang}-error-handling` — always
- `{plugin}:{lang}-style` — always
- `{plugin}:{lang}-context` — if the code involves request lifecycles
- `{plugin}:{lang}-concurrency` — if the code involves concurrent work
- `{plugin}:{lang}-database` — if the code involves database access

If a spec file exists (SPEC-*.md), pass it as context to the agent.
Build and run affected tests before reporting done.
