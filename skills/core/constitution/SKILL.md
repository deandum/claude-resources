---
name: constitution
description: >
  Author and maintain a project constitution — the list of invariants
  reviewer and critic enforce on every spec and every diff. Use when
  adding, editing, or sunsetting project-wide non-negotiables.
---

# Constitution

A constitution is the list of invariants that must hold across every spec, every group, every review. Skills teach patterns; the constitution enforces outcomes.

## When to Use

- Starting a new project and codifying non-negotiables before the first feature
- A post-incident review reveals a rule that should have been caught mechanically
- A recurring review comment ("don't do X") needs to be promoted from convention to enforcement
- An invariant becomes obsolete and needs to be sunset

## When NOT to Use

- Style nudges — those belong in a linter config or `core/style`
- One-off decisions — those belong in a commit message or ADR
- Nice-to-haves — if you would accept a PR that violates it, it is not an invariant
- Framework-level rules for consumers — those belong in `CLAUDE.md` of the consumer project

## Core Process

1. **Locate or create the constitution.** Consumers: copy `EXAMPLE_CONSTITUTION.md` to `docs/constitution.md`. This framework's own constitution lives at `docs/constitution.md`.
2. **State the invariant.** One paragraph answering: what must be true, and what does a violation look like?
3. **Pick severity honestly.** `critical` = reviewer blocks advancement. `important` = reviewer flags but does not block. If you would accept exceptions, it is `important`.
4. **Narrow the scope.** "All code" is almost never right. State exact paths, packages, or file patterns.
5. **Describe detection concretely.** Reviewer needs a grep-able signal or a specific pattern to match. Vague detection = unenforced invariant.
6. **Register in frontmatter.** Add `{id, severity}` to the YAML `invariants:` list. `hooks/session-start.sh` reads this list and emits `project_constitution` into session context.
7. **Verify enforcement.** Author a deliberate violation in a test branch, run `/review`, confirm reviewer flags it at the expected severity.

## Invariant Anatomy

Every invariant has two parts: a frontmatter entry that agents read from session context, and a body section with the human-readable detail.

**Frontmatter entry** (registered in `docs/constitution.md` YAML):

```yaml
---
title: Project Constitution
invariants:
  - id: no-silent-failures
    severity: critical
  - id: public-function-tested
    severity: important
---
```

**Body section** (one per invariant, six fields):

- **id** — `kebab-case-id`, short, memorable, grep-able in reviewer output. Matches the frontmatter entry.
- **Severity** — `critical` or `important`. No third tier.
- **Enforced by** — which agent owns the check: `reviewer`, `critic`, or both. Reviewer inspects diffs; critic inspects specs. Pick the agent that actually has the relevant context.
- **Scope** — exact files, packages, or patterns where the invariant applies.
- **Rationale** — one paragraph future-you will not forget the reason.
- **Detection** — concrete pattern reviewer can grep or match against.

## Severity

| Level | Reviewer Behavior | Critic Behavior |
|-------|-------------------|-----------------|
| `critical` | Violation forces a Critical finding; status becomes `needs-input`; group cannot advance without explicit user acceptance | Violation becomes a `Blocker: yes` clarifying question — the spec cannot be synthesized as written |
| `important` | Violation contributes to Important findings; status becomes `needs-input`; user must accept before advance | Violation becomes a suggested scope hazard to fold into `Out of Scope` or `Ask first` |

## Pair With

- `core/code-review` — reviewer loads the constitution as a sixth check after the five axes
- `core/spec-generation` — lead mirrors `critical` invariants into the spec's `Never do` tier verbatim
- `core/skill-discovery` — routes "authoring or modifying project invariants" to this skill

## Common Rationalizations

| Shortcut | Reality |
|----------|---------|
| "Everyone knows this rule; no need to codify" | Unwritten rules are only enforced by whoever remembers them. Reviewer and critic have no memory between sessions. |
| "Style nits should be here too" | Mixing invariants with style creates noise. Reviewers stop reading long lists. Lint the style; constitutionalize the invariants. |
| "Severity doesn't matter, I'll mark everything critical" | Reviewer blocks every PR on every item. Authors route around by marking as "exception." Severity loses meaning. |
| "We can leave obsolete invariants in place; they just won't fire" | Dead rules poison the list — readers treat active rules with the same scrutiny as inactive ones. Sunset or delete. |

## Red Flags

- Invariant list exceeds 10 items — probably conflating invariants with conventions
- `Scope: all code` on most invariants — suggests the rule is actually narrower
- No `Detection` clause, or detection is "reviewer judges" — reviewer has no reliable signal
- An invariant that has never caught a violation in practice — either wrongly scoped or unneeded
- `critical` severity on more than half the list — severity is no longer discriminating

## Verification

- [ ] `docs/constitution.md` exists at project root
- [ ] YAML frontmatter contains `title:` and `invariants:` list with `{id, severity}` per item
- [ ] Each invariant has all five body fields: Severity, Enforced by, Scope, Rationale, Detection
- [ ] `hooks/session-start.sh` emits `project_constitution` field when the file is present
- [ ] Reviewer flags a deliberate violation at the expected severity
- [ ] Total invariant count is between 3 and 10
