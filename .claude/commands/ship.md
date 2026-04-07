---
description: Containerize and add observability for production
---

## Language Detection

Detect the project language from marker files:
- `go.mod` → lang=go, plugin=go-skills
- `package.json` + `angular.json` → lang=angular, plugin=angular-skills
- `package.json` (no angular) → lang=node, plugin=node-skills
- `Cargo.toml` → lang=rust, plugin=rust-skills
- `pyproject.toml` or `requirements.txt` → lang=python, plugin=python-skills

## Task

Spawn the shipper agent (subagent_type: `{plugin}:{lang}-shipper`) with this task: $ARGUMENTS

The shipper agent has `core/docker` and `core/observability` skills loaded.

Invoke the `{plugin}:{lang}-docker` skill for containerization patterns.
Invoke the `{plugin}:{lang}-observability` skill for logging, metrics, and tracing.

Audit what exists first. Then add in order:
1. Structured logging → 2. Health checks → 3. Metrics → 4. Dockerfile
Verify: build image, check size, test health endpoint.
