---
name: observability
description: >
  Language-agnostic observability principles. Three pillars (logs, metrics,
  traces), structured logging, instrumentation methods. Use with
  language-specific observability skill for SDK patterns.
---

# Observability

Log only actionable information. Where logging is expensive, instrumentation is cheap.

## Three Pillars

1. **Logs** — discrete events, structured key-value pairs
2. **Metrics** — numerical measurements aggregated over time
3. **Traces** — request flow across service boundaries

## Structured Logging

### Log Levels

- `Info` — significant state changes, request completion, startup/shutdown
- `Error` — failures needing human attention or automated alerting
- `Debug` — detailed diagnostics, off in production by default
- `Warn` — unusual situations that might indicate problems

### Rules

- Log at service boundaries, not inside every function
- Use structured fields, not string interpolation
- Never log sensitive data (passwords, tokens, PII)
- Each log line should be independently useful
- Include correlation/request IDs for traceability

## Metrics

### RED Method (for services)

- **R**ate — requests per second
- **E**rrors — failed requests per second
- **D**uration — latency distributions

### USE Method (for resources)

- **U**tilization — how full is the resource
- **S**aturation — how much queued work
- **E**rrors — error count

### Rules

- No high-cardinality labels (no user IDs or request IDs as metric labels)
- Use histograms for latency, counters for totals, gauges for current state

## Distributed Tracing

- Create spans at service boundaries and significant operations
- Propagate trace context across service calls
- Record errors on spans
- Add relevant attributes (IDs, operation names)

## Health Checks

- Liveness (`/healthz`): process alive? Always 200 if running.
- Readiness (`/readyz`): ready for traffic? Check dependencies (DB, cache).

## Anti-Patterns

- Logging everything — log at boundaries, not every function
- High-cardinality metric labels — causes metric explosion
- Missing error context — unhandled errors must be logged at top level
- No timeouts — every external call needs a timeout
- Logging sensitive data — never log passwords, tokens, PII
