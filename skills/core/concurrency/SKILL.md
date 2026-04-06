---
name: concurrency
description: >
  Language-agnostic concurrency patterns and pitfalls. Pattern catalog,
  decision frameworks, and anti-patterns. Use with language-specific
  concurrency skill for implementation details.
---

# Concurrency

Don't communicate by sharing memory; share memory by communicating.
Concurrency is not parallelism.

## Decision: Message Passing vs Shared State

| Message Passing (channels/queues) | Shared State (locks/atomics) |
|---|---|
| Transferring ownership of data | Protecting internal state |
| Coordinating workers | Simple counter or flag |
| Distributing work | Short critical sections |
| Signaling events | Cache access |

**Rule of thumb**: transferring data -> message passing. Protecting data -> shared state.

## Pattern Catalog

| Pattern | Use When |
|---------|----------|
| Worker Pool | Fixed concurrency processing a stream of work items |
| Fan-Out/Fan-In | Multiple independent tasks, collect all results |
| Pipeline | Sequential processing stages connected by queues |
| Rate Limiter | Throttle operations (API calls, DB queries) |
| Once Init | Lazy initialization that must happen exactly once |
| Deduplication | Suppress duplicate concurrent calls for same key |
| Object Pool | Reuse temporary objects to reduce allocation pressure |

## Rules

- Every concurrent task must have a clear shutdown path
- Use cancellation tokens/contexts for cooperative cancellation
- Bound concurrency — never spawn unlimited concurrent tasks
- Prefer higher-level abstractions (task groups, executors) over raw threads/goroutines

## Anti-Patterns

- **Resource leak** — concurrent task with no way to stop it
- **Race condition** — unsynchronized access to shared state
- **Message passing misuse** — using channels/queues when a simple lock is clearer
- **Unbounded concurrency** — spawning unlimited tasks (memory exhaustion, connection storms)
- **Deadlock** — circular wait on locks or full channels
