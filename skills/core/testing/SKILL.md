---
name: testing
description: >
  Language-agnostic testing strategy. Test pyramid, unit vs integration
  decisions, mocking boundaries, and anti-patterns. Use with language-specific
  testing skill for implementation patterns.
---

# Testing Strategy

Tests are code. Apply same quality standards as production code.

## Core Principles

1. Test behavior, not implementation — test the public API
2. Make it easy to add new test cases — if adding a case is hard, refactor
3. Each test must be independent — no shared mutable state
4. Prefer real implementations over mocks where feasible

## Test Pyramid

1. **Unit Tests** (70-80%) — fast, isolated, mock boundaries, test business logic
2. **Integration Tests** (15-25%) — real adapters (DB, queues), verify infrastructure
3. **End-to-End Tests** (5-10%) — full workflows, critical journeys only, keep minimal

## Decision: Unit vs Integration?

| Scenario | Test Type | Approach |
|----------|-----------|----------|
| Business logic | Unit | Mock dependencies |
| Database queries | Integration | Real database |
| HTTP handlers | Unit | Mock service layer |
| Repository CRUD | Integration | Real database |
| External API calls | Unit | Mock HTTP client |
| Full API workflow | E2E | Real services |

## Mocking Boundaries

**Mock these** (cross system boundaries):
- Database repositories, HTTP clients, message queues, email/SMS services, cache clients

**Don't mock these** (internal to app):
- Domain entities, value objects, pure functions, internal packages

### Mock Decision Framework

1. **Does dependency cross a system boundary?** Yes -> mock it. No -> use real implementation.
2. **Do different tests need different behavior?** Yes -> function-based mock. No -> struct-based stub.
3. **Need to verify how dependency was called?** Yes -> mock with capture. No -> stub returning test data.

## Anti-Patterns

- Testing private/internal functions — test public API; privates are implementation details
- Complex test setup — indicates tight coupling; simplify design first
- Mocking everything — only mock at boundaries; over-mocking makes tests brittle
- Mixing unit and integration tests — separate them clearly
- Using sleep for synchronization — use proper sync primitives
- Asserting on log output — test behavior, not logging side effects
- Shared mutable state between tests — each test must be independent

## Test Organization

- Unit tests: co-located with production code
- Integration tests: separate directory (e.g., `test-integration/`)
- Each test file mirrors the file it tests
