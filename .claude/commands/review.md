---
description: Review code for correctness, security, and quality
---

## Language Detection

Detect the project language from marker files:
- `go.mod` → lang=go, plugin=go-skills
- `package.json` + `angular.json` → lang=angular, plugin=angular-skills
- `package.json` (no angular) → lang=node, plugin=node-skills
- `Cargo.toml` → lang=rust, plugin=rust-skills
- `pyproject.toml` or `requirements.txt` → lang=python, plugin=python-skills

## Task

Spawn the reviewer agent (subagent_type: `{plugin}:{lang}-reviewer`) with this task: $ARGUMENTS

The reviewer agent has `core/code-review` and `core/style` skills loaded.

Invoke the `{plugin}:{lang}-code-review` skill for the language-specific review checklist.
Invoke the `{plugin}:{lang}-error-handling` skill to verify error handling patterns.
Invoke the `{plugin}:{lang}-concurrency` skill if the code involves concurrent work.

The reviewer is read-only — it reports findings but does not modify code.
Every finding must have a severity label: Critical, Important, Suggestion, Nit, or FYI.
