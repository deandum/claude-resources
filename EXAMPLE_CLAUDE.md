# Project: [PROJECT NAME]

> [One-line description of what this project does and why it exists.]

## Tech Stack

<!-- Adjust for your language/framework -->
- **Language:** Go 1.24+
- **Router:** chi
- **Database:** MySQL with sqlx
- **Config:** envconfig (services) / Viper (CLI)
- **Logging:** slog (stdlib)
- **Metrics:** Prometheus
- **Tracing:** OpenTelemetry
- **Testing:** stdlib (default) or Ginkgo/Gomega (if adopted)
- **Linting:** golangci-lint

## Agent Workflow

**MANDATORY: Every user prompt MUST be routed to the critic agent first.** Do not begin any implementation, design, or analysis work until critic has analyzed the request and produced a structured task definition. No exceptions.

After critic approves the task, use the appropriate agents:

1. **critic** - ALWAYS FIRST. Analyzes every prompt for clarity, completeness, and feasibility.
2. **architect** - Design phase. Package layout, interfaces, API surface.
3. **builder** - Implementation. Writes application code following established patterns.
4. **cli-builder** - CLI-specific implementation. Use instead of builder for CLI commands.
5. **tester** - Write and run tests after implementation.
6. **reviewer** - Code review. Read-only. Run after implementation and testing.
7. **shipper** - Containerization and observability. Dockerfile, logging, metrics, health checks.

## Do NOT

- Add features, abstractions, or "improvements" that weren't asked for
- Create helpers or utilities for one-time operations
- Add comments to code you didn't change or self-documenting code
- Run as root in containers
- Hardcode credentials, connection strings, or secrets
- Commit generated files, binaries, or `.env` files
