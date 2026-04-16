---
title: Project Constitution
invariants:
  - id: no-silent-failures
    severity: critical
  - id: public-function-tested
    severity: important
  - id: no-secrets-in-code
    severity: critical
---

# Project Constitution

Invariants that must hold across every spec, every group, every review. Copy this file to `docs/constitution.md` in your project, then edit the invariants below to match your project's non-negotiables.

Agents read `project_constitution` from session context (emitted by `hooks/session-start.sh` when this file exists) and enforce each invariant. `critical` violations block merge; `important` violations surface as Important findings.

## How to Use

- **Keep the list small.** 3–10 invariants. A constitution with 50 items is a checklist, not a set of principles.
- **Invariants are what must be true.** Not style nudges, not nice-to-haves. If you'd accept a PR that violates it, it is not an invariant.
- **Severity matters.** `critical` blocks advancement; `important` gets flagged but does not block. Use `critical` sparingly.
- **Every invariant cites a scope.** Reviewer needs to know where it applies (all code, HTTP handlers only, migrations only, etc.).

## Invariants

### no-silent-failures

- **Severity**: critical
- **Enforced by**: reviewer
- **Scope**: all application code
- **Rationale**: A caught error that is not logged, wrapped, or returned becomes an invisible bug that surfaces hours later in production. Every error path must do one of: return the error, wrap it with context, or log it at an appropriate level.
- **Detection**: any `_ = err` pattern, any bare `catch` block that does nothing, any `if err != nil { return nil }` that discards the error.

### public-function-tested

- **Severity**: important
- **Enforced by**: reviewer
- **Scope**: all packages under `internal/` and `pkg/`
- **Rationale**: Exported functions form the package's contract with the rest of the codebase. Untested exports change meaning without anyone noticing.
- **Detection**: any exported function/method without at least one direct test covering the happy path and one error path.

### no-secrets-in-code

- **Severity**: critical
- **Enforced by**: reviewer, critic
- **Scope**: all files outside `.env.example` and test fixtures explicitly marked `// fixture: not-a-real-secret`
- **Rationale**: Secrets in source history never fully disappear. Rotation becomes the only remediation.
- **Detection**: any string matching `password|secret|token|api[-_]?key` with a non-placeholder value; any connection string with credentials baked in.

<!--
## Adding an Invariant

1. Name it `kebab-case-id` — short, memorable, grep-able in reviewer output.
2. Pick severity honestly. If you'd accept exceptions, it's `important`. If you'd reject the PR every time, it's `critical`.
3. Write a one-paragraph Rationale — future-you will forget why.
4. State the Scope narrowly. "All code" is almost never right.
5. Describe Detection concretely so reviewer has something to grep for.
6. Add the `id` + `severity` to the frontmatter list. Agents read that list on every session.

## Sunsetting an Invariant

Invariants should be permanent. If one becomes obsolete, remove it entirely rather than leaving it as a zombie. Commit the removal with a one-line reason in the commit message.
-->
