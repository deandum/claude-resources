---
task: <slug>
created: <ISO-8601 date>
---

# Contracts: [Task Title]

Written by `architect` when the spec is API/data-heavy. Endpoints, payload shapes, error codes, events — the stable interface builder implements and tester verifies.

If a section has no content for this task, state `_None._` rather than deleting the heading. Reviewer uses the presence of each section as a checklist.

## Endpoints

| Method | Path | Purpose | Auth |
|--------|------|---------|------|
| POST | /api/v1/resource | [one-line purpose] | bearer token |
| GET | /api/v1/resource/{id} | [one-line purpose] | bearer token |

## Request Schemas

### POST /api/v1/resource

```json
{
  "field_a": "string (required, max 256 chars)",
  "field_b": "integer (required, >= 0)",
  "field_c": "string (optional, default null)"
}
```

### GET /api/v1/resource/{id}

_No request body. Path parameter `id`: UUID v4._

## Response Schemas

### Success

```json
{
  "id": "uuid",
  "field_a": "string",
  "field_b": "integer",
  "created_at": "ISO-8601 timestamp"
}
```

### Error

```json
{
  "error": {
    "code": "string (see Error Codes)",
    "message": "string (human-readable)",
    "details": "object (optional, per-error-code shape)"
  }
}
```

## Error Codes

| Code | HTTP Status | Condition | Response `details` |
|------|-------------|-----------|--------------------|
| `invalid_request` | 400 | Malformed JSON or missing required field | `{ field: name, reason: string }` |
| `unauthorized` | 401 | Missing or invalid bearer token | _None._ |
| `not_found` | 404 | Resource does not exist | `{ id: string }` |
| `conflict` | 409 | Unique constraint violation | `{ field: name }` |
| `internal` | 500 | Server-side failure | _None. Logged server-side only._ |

## Events

Emitted events (if this spec publishes to a queue, stream, or webhook). One section per event type.

- **`resource.created`** — emitted after successful POST. Payload matches the success response schema.
- **`resource.deleted`** — emitted after successful DELETE. Payload: `{ "id": "uuid", "deleted_at": "ISO-8601" }`.

_None._ if the task does not publish events.

## Data Invariants

Cross-cutting rules the endpoints uphold. Reviewer treats violations as Critical findings.

- **[Invariant]** — [e.g., "email addresses are case-insensitive on lookup: stored and compared as lowercase."]
- **[Invariant]** — [e.g., "soft-deleted rows are excluded from GET responses but retained in the database."]

_None._ if none apply.
