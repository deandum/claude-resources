---
name: api-design
description: >
  Language-agnostic HTTP API design principles. REST conventions, handler
  structure, middleware, versioning, and error responses. Use with
  language-specific api-design skill for framework patterns.
---

# API Design

Design clear, consistent APIs. Separate transport from domain logic.

## Handler Pattern

Every handler follows: **parse -> validate -> execute -> respond**.

1. Parse request (decode body, extract params)
2. Validate input (reject early with 400)
3. Execute business logic (call service layer)
4. Respond (map result to HTTP response)

## Request/Response Types

Keep HTTP-layer types separate from domain types:
- Request DTOs: parse + validate input, convert to domain types
- Response DTOs: map domain types to API representation
- Never expose domain entities directly in API responses

## Error Responses

- Map domain errors to HTTP status at the boundary
- Consistent error body format: `{"error": "message"}`
- Domain code stays transport-agnostic

| Domain Error | HTTP Status |
|-------------|-------------|
| NotFound | 404 |
| Validation | 400 or 422 |
| Conflict | 409 |
| Forbidden | 403 |
| Unauthorized | 401 |
| Internal | 500 (log error, return generic message) |

## Middleware

Layer cross-cutting concerns as middleware:
- Request ID generation/propagation
- Logging (method, path, status, duration)
- Panic recovery
- Authentication/authorization
- CORS, compression, rate limiting

Apply middleware broadly or to specific route groups.

## Versioning

- URL path versioning: `/api/v1/users` (simplest, most explicit)
- Keep old version handlers when introducing new versions
- Separate handler structs per major version if APIs diverge

## Server Configuration

Never use default server/client configs in production:
- Set read/write/idle timeouts
- Configure connection pool limits for HTTP clients
- Use graceful shutdown with signal handling

## Health Checks

- `/healthz` — is the process alive? (always 200 if running)
- `/readyz` — is the service ready for traffic? (checks dependencies)
