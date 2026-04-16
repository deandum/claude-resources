---
title: claude-resources Constitution
invariants:
  - id: core-skills-language-agnostic
    severity: critical
  - id: frontmatter-contract-intact
    severity: critical
  - id: new-skill-fully-registered
    severity: critical
  - id: skill-has-verification-section
    severity: important
  - id: core-skill-no-supporting-files
    severity: important
---

# claude-resources Constitution

Invariants for this framework itself. Mirrors the Boundaries section of [CLAUDE.md](../CLAUDE.md) into enforceable form — reviewer and critic grade every change against this list.

## Invariants

### core-skills-language-agnostic

- **Severity**: critical
- **Enforced by**: reviewer, critic
- **Scope**: every file under `skills/core/`
- **Rationale**: Core skills are loaded by every language. Smuggling Go idioms, Python imports, or Rust syntax into a core skill breaks every non-Go consumer and corrupts the skill's purpose. Language-specific content belongs in `skills/<lang>/`.
- **Detection**: any `go`/`python`/`rust`/`java` fenced code block in a core `SKILL.md`; any path reference to `*.go`, `pyproject.toml`, `Cargo.toml` inside `skills/core/`.

### frontmatter-contract-intact

- **Severity**: critical
- **Enforced by**: reviewer
- **Scope**: YAML frontmatter on every `SKILL.md`, agent `.md`, and slash command `.md`
- **Rationale**: Tooling, hooks, and other agents read the frontmatter as a typed contract. Renaming `name` → `title`, dropping `description`, or changing the `skills:` list shape silently breaks consumers.
- **Detection**: diff removes or renames any required field (`name`, `description` on skills; `name`, `description`, `tools`, `model`, `skills`, `memory` on agents; `description` on commands).

### new-skill-fully-registered

- **Severity**: critical
- **Enforced by**: reviewer
- **Scope**: any PR adding a directory under `skills/core/`, `skills/go/`, or `skills/<new-lang>/`
- **Rationale**: An unregistered skill is invisible to the plugin loader — it ships but never loads. Every new skill must land in three places atomically.
- **Detection**: new skill directory without a matching entry in `.claude-plugin/marketplace.json`, without a routing entry in `skills/core/skill-discovery/SKILL.md`, or without an updated `README.md` skill count and list.

### skill-has-verification-section

- **Severity**: important
- **Enforced by**: reviewer
- **Scope**: every `SKILL.md` file
- **Rationale**: The Verification section is how an agent confirms the skill was applied correctly. A skill without verification is guidance without a pass/fail signal.
- **Detection**: `SKILL.md` missing a `## Verification` heading, or whose Verification section contains zero checklist items.

### core-skill-no-supporting-files

- **Severity**: important
- **Enforced by**: reviewer
- **Scope**: every directory under `skills/core/` except `skills/core/spec-generation/`
- **Rationale**: Core skills are meant to fit in one `SKILL.md`. Supporting files signal the skill has grown past its intended scope or should be split. `spec-generation` is grandfathered — its four spec-directory templates are load-bearing and exceed inline embedding.
- **Detection**: any file other than `SKILL.md` in a `skills/core/<name>/` directory, other than the spec-generation exception.
