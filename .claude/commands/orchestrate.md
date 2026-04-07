---
description: Decompose a complex task and delegate to specialist agents
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

The lead agent has the `core/spec-generation` skill and the Agent tool for delegation.

Workflow:
1. Lead spawns critic (subagent_type: `{plugin}:{lang}-critic`) to clarify and decompose
2. Lead generates `SPEC-[task-slug].md` with subtasks organized in execution waves
3. User approves the spec
4. Lead executes waves — one agent per subtask, parallel within waves:
   - architect (`{plugin}:{lang}-architect`) for structure/design
   - builder (`{plugin}:{lang}-builder`) for implementation
   - cli-builder (`{plugin}:{lang}-cli-builder`) for CLI work
   - tester (`{plugin}:{lang}-tester`) for tests
   - reviewer (`{plugin}:{lang}-reviewer`) for review
   - shipper (`{plugin}:{lang}-shipper`) for deployment
5. Lead verifies results against spec success criteria

The spec IS the prompt for each agent. Do not start without user approval.
