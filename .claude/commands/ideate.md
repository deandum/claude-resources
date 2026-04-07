---
description: Refine a vague idea into a task ready for /define
---

## Language Detection

Detect the project language from marker files:
- `go.mod` → lang=go, plugin=go-skills
- `package.json` + `angular.json` → lang=angular, plugin=angular-skills
- `package.json` (no angular) → lang=node, plugin=node-skills
- `Cargo.toml` → lang=rust, plugin=rust-skills
- `pyproject.toml` or `requirements.txt` → lang=python, plugin=python-skills

## Task

Spawn the critic agent (subagent_type: `{plugin}:{lang}-critic`) with this idea: $ARGUMENTS

Invoke the core-skills:idea-refine skill for the ideation process.

Work through three phases:
1. **Understand & Expand** — restate as "How Might We", generate 5-8 variations
2. **Evaluate & Converge** — stress-test value/feasibility/differentiation, surface assumptions
3. **Sharpen & Ship** — produce a task statement with problem, direction, Not Doing list

Output a concrete artifact ready for `/define` to turn into a structured spec.
