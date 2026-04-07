---
description: Write and run tests for the codebase
---

## Language Detection

Detect the project language from marker files:
- `go.mod` → lang=go, plugin=go-skills
- `package.json` + `angular.json` → lang=angular, plugin=angular-skills
- `package.json` (no angular) → lang=node, plugin=node-skills
- `Cargo.toml` → lang=rust, plugin=rust-skills
- `pyproject.toml` or `requirements.txt` → lang=python, plugin=python-skills

## Task

Spawn the tester agent (subagent_type: `{plugin}:{lang}-tester`) with this task: $ARGUMENTS

The tester agent has the `core/testing` skill loaded for test strategy.

Invoke the `{plugin}:{lang}-testing` skill for language-specific test patterns.
If the project uses an alternative test framework (e.g., Ginkgo/Gomega for Go),
invoke `{plugin}:{lang}-testing-with-framework` instead.

Run tests with race detection (where available) after writing.
Fix failures before reporting done.
