---
name: error-handling
description: >
  Language-agnostic error handling strategy. Decision framework for error
  types, propagation patterns, and anti-patterns. Use with language-specific
  error-handling skill for implementation details.
---

# Error Handling

Errors are values. Handle them gracefully, not just check them.

## Decision Framework

Ask in order:

1. **Caller needs to programmatically distinguish this error?**
   - Yes -> sentinel error or custom error type
   - No -> wrapped error with context string

2. **Error is a static condition with no runtime data?**
   - Yes -> sentinel error constant/variable
   - No -> custom error type with fields, or wrapped error

3. **Error carries structured data the caller needs?**
   - Yes -> custom error type
   - No -> wrapped error with context string

## Error Categories

| Category | When | Example |
|----------|------|---------|
| Sentinel errors | Well-known conditions, multiple callers branch on it | NotFound, AlreadyExists, Forbidden |
| Custom error types | Caller needs structured data (field, code, resource) | ValidationError, NotFoundError |
| Wrapped errors | Default — add context as you propagate up | "finding user %s: %w" |
| Multi-error | Operation can fail in multiple independent ways | Config validation, batch processing |

## Wrapping Rules

- Lowercase, no trailing punctuation
- Describe the operation that failed, not the function name
- Include relevant identifiers: "finding user %s" not "finding user"
- Preserve the error chain for type/value checking

## Anti-Patterns

- **Don't panic** — panic for programmer bugs only (invalid state, impossible conditions)
- **Don't ignore errors** — every error return must be checked
- **Don't use string matching** — use typed/value error checking, never string contains
- **Don't over-wrap** — add useful context, not redundant function names
- **Don't log and return** — either log or return with context, never both (duplicate logging)

## Package Error Contracts

Document each package's error contract: which errors it returns, when, and how callers should handle them.

## Boundary Mapping

Map domain errors to transport-layer responses at the boundary (HTTP handler, gRPC interceptor, CLI exit code). Keep domain errors transport-agnostic.
