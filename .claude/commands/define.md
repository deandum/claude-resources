---
description: Analyze task requirements and generate a structured spec
---

## Language Detection

Detect the project language from marker files:
- `go.mod` → lang=go, plugin=go-skills
- `package.json` + `angular.json` → lang=angular, plugin=angular-skills
- `package.json` (no angular) → lang=node, plugin=node-skills
- `Cargo.toml` → lang=rust, plugin=rust-skills
- `pyproject.toml` or `requirements.txt` → lang=python, plugin=python-skills

## Task

Spawn the lead agent (subagent_type: `{plugin}:{lang}-lead`) with this task: $ARGUMENTS

The lead agent has the `core/spec-generation` skill loaded and will:
1. First spawn the critic agent to clarify requirements and surface gaps
2. Generate `SPEC-[task-slug].md` using the spec template
3. Present the spec for user approval before any execution

Do not proceed to implementation without explicit user approval of the spec.
If the task is too vague even for a spec, suggest running `/ideate` first.
