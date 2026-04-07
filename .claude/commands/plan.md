---
description: Design architecture and project structure
---

## Language Detection

Detect the project language from marker files:
- `go.mod` → lang=go, plugin=go-skills
- `package.json` + `angular.json` → lang=angular, plugin=angular-skills
- `package.json` (no angular) → lang=node, plugin=node-skills
- `Cargo.toml` → lang=rust, plugin=rust-skills
- `pyproject.toml` or `requirements.txt` → lang=python, plugin=python-skills

## Task

Spawn the architect agent (subagent_type: `{plugin}:{lang}-architect`) with this task: $ARGUMENTS

The architect agent has `core/project-structure` and `core/api-design` skills loaded,
plus language-specific skills auto-detected from the project.

Invoke the `{plugin}:{lang}-project-init` skill if scaffolding a new project.
Invoke the `{plugin}:{lang}-interface-design` skill if defining contracts.
Invoke the `{plugin}:{lang}-api-design` skill if designing HTTP/gRPC surfaces.

Present the proposed design for user approval before generating any files.
