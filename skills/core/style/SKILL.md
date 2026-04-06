---
name: style
description: >
  Language-agnostic code quality principles. Naming clarity, formatting,
  function design, and universal anti-patterns. Use with language-specific
  style skill for conventions and linting.
---

# Code Style

Clear is better than clever. Every line should be immediately understandable.

## Core Principles

- **Simplicity is the goal**, not the starting point. Don't add abstractions until code demands them.
- **Explicit over implicit**. Boring over brilliant.
- **Consistency** within a codebase trumps personal preference.

## Naming

- Names describe purpose, not type: `users` not `userSlice`
- Short names for narrow scopes, descriptive for wide scopes
- Package/module names describe what they *provide*, not what they *contain*
- Avoid generic names: `util`, `common`, `helpers`, `misc` — these are code smells
- Boolean variables/functions: `Is`, `Has`, `Can` prefixes

## Function Design

- Each function does exactly one thing well
- Keep functions short (~100 lines max). If longer, consider splitting.
- Early returns for error/edge cases — keep happy path at minimal indentation
- Limit parameters (>4 suggests a config struct or builder)

## Formatting

- Use the language's standard formatter — non-negotiable
- Consistent import grouping: stdlib, external, internal
- No manual alignment of fields or comments

## Comments

- Comments explain *why*, not *what* (the code shows what)
- All public/exported names should have doc comments
- Delete commented-out code — version control remembers

## Anti-Patterns

- God objects/structs with too many fields or methods
- Interfaces with too many methods (keep small, 1-5 ideal)
- Deep nesting (>3 levels)
- Naked boolean parameters — use named types or option structs
- `any`/`object`/`interface{}` when a concrete type would work
- Premature abstraction — three similar lines beat a premature helper
