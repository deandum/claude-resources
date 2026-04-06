---
name: project-structure
description: >
  Language-agnostic project structure principles. Entity-focused architecture,
  separation of concerns, dependency direction. Use with language-specific
  project-init skill for directory layouts and scaffolding.
---

# Project Structure

Organize code by domain entity, not by technical layer.

## Entity-Focused Architecture

Group code by business entity (user, order, product), not by type (controllers, models, services).

Each entity package encapsulates:
- **Domain logic**: entity types, value objects, validation rules
- **Ports**: repository and service interfaces
- **Use cases**: business logic and orchestration
- **Adapters**: HTTP handlers, DB implementations

### Benefits

- High cohesion: related code lives together
- Low coupling: packages depend on each other via interfaces
- Easy navigation: working on "user" features = one package
- Natural scaling: adding entities doesn't bloat existing packages

## Cross-Cutting Concerns

Shared infrastructure lives in dedicated packages:
- HTTP middleware, routing, error responses
- Database connection pool, transaction helpers
- Shared utilities (use sparingly — avoid "util" packages)

## Dependency Rules

- Entity packages can import other entity packages via interfaces
- Entity packages can import cross-cutting packages
- Cross-cutting packages must NOT import entity packages (avoids cycles)
- Dependencies flow inward: adapters -> use cases -> domain

## Project Types

| Type | Structure |
|------|-----------|
| Service (HTTP/gRPC) | cmd/ + internal/ (entity packages + cross-cutting) + migrations/ |
| CLI Tool | cmd/ + internal/ (commands + config) |
| Library | root package API + internal/ + examples/ |

## Scaffolding Checklist

- Linter config present and passing
- Tests run and pass
- Build produces artifact
- Container build succeeds
- README documents how to run locally
- Environment variables documented
