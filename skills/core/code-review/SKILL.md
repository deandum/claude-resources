---
name: code-review
description: >
  Language-agnostic code review process. Review categories, output format,
  and severity levels. Use with language-specific code-review skill for
  language-specific checklist items.
---

# Code Review

Systematic review process. Work through categories in order. Report findings per category.

## Review Categories (in order)

1. **Correctness** — error handling, concurrency, resource management, nil/null safety
2. **Style and Naming** — formatting, naming, code organization
3. **Design** — package/module design, API surface, dependencies, coupling
4. **Testing** — coverage, test quality, race safety
5. **Performance** — allocations, N+1 queries, timeouts, unbounded operations
6. **Security** — secrets, injection, input validation, TLS

## Output Format

```
## Review Summary

**Overall**: [APPROVE / REQUEST CHANGES / COMMENT]

### Critical (must fix)
- file:line — description of issue

### Important (should fix)
- file:line — description of issue

### Suggestions (nice to have)
- file:line — description of improvement
```

## Severity Levels

| Level | Meaning | Action |
|-------|---------|--------|
| Critical | Security vulnerability, data loss, crash, resource leak | Must fix before merge |
| Important | Bug risk, missing error handling, design issue | Should fix before merge |
| Suggestion | Style improvement, minor optimization, readability | Nice to have |
