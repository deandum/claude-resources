# Hooks

Reference for the shell scripts under `hooks/`. All are pure bash (bash 4+). Triggered automatically by Claude Code's session events (registered in `hooks/hooks.json`) or invoked manually by agents.

## Lifecycle hooks

### session-start.sh

**Fires on:** `SessionStart` event (registered in `hooks/hooks.json`)

**What it does:**

1. Detects project languages from marker files in the current working directory (`go.mod`, `package.json`, `Cargo.toml`, `pyproject.toml`, `requirements.txt`, `angular.json`)
2. Lists available core skills from `skills/core/`
3. Lists available language skills for detected languages
4. Detects whether `skills/ops/` is populated (for the opt-in ops plugin)
5. Reads the last 10 operational learnings from `~/.claude-resources/learnings/{project-slug}.jsonl`
6. Scans `docs/specs/*/spec.md` for in-progress specs (`status != complete`) and extracts frontmatter `current_group`/`total_groups`
7. **Probes third-party integrations**: 8 known CLI tools, MCP servers from `~/.claude.json` / `./.mcp.json`, user-scope skills / agents / plugins under `~/.claude/`
8. Emits a single JSON object to stdout, which Claude Code injects into the session context

**Output schema:**

```json
{
  "priority": "IMPORTANT",
  "detected_languages": "go",
  "core_skills": "api-design,code-review,...",
  "language_skills": "go: [api-design,cli,...]",
  "ops_enabled": true,
  "ops_skills": "git-remote,pull-requests,release,registry",
  "available_tools": "jq,rg,gh,docker",
  "missing_tools": "ast-grep,fd,yq,kubectl",
  "mcp_servers": "playwright,magic,memory",
  "user_skills": "",
  "user_agents": "",
  "user_plugins": "claude-code-workflows,code-review-ai",
  "recent_learnings": "learning 1; learning 2; ...",
  "active_specs": "rate-limiter:2/4, cache-refactor:0/3",
  "style": "Apply core/token-efficiency (standard) to human-facing output only. ...",
  "external_writes_policy": "Agents MUST check ops_enabled before executing any remote-write command...",
  "spec_resumption_policy": "When active_specs is non-empty, lead surfaces the in-progress specs..."
}
```

**Fields:**

| Field | Type | Description |
|---|---|---|
| `priority` | string | Always `IMPORTANT` — signals high-value context |
| `detected_languages` | string | Space-separated language codes |
| `core_skills` | string | Comma-separated core skill directory names |
| `language_skills` | string | Per-language skill lists |
| `ops_enabled` | boolean | `true` if `skills/ops/` is populated, else `false` |
| `ops_skills` | string | Comma-separated ops skill names (empty if `ops_enabled=false`) |
| `available_tools` | string | Comma-joined CLI tools present on PATH from the fixed probe list: `ast-grep`, `fd`, `rg`, `jq`, `yq`, `gh`, `docker`, `kubectl`. Empty if none present. |
| `missing_tools` | string | Complement of `available_tools` — probed tools not on PATH. Agents use this to explain fallback decisions, never to nag the user. |
| `mcp_servers` | string | Comma-joined names of MCP servers extracted from `~/.claude.json` (top-level + per-project), `~/.claude/settings.json`, and `./.mcp.json`. Only server names — never `command`/`args`/`env` (secret hygiene). Empty if none configured. |
| `user_skills` | string | Comma-joined directory names under `~/.claude/skills/`. User-scope skills installed outside this framework. |
| `user_agents` | string | Comma-joined directory names under `~/.claude/agents/`. User-scope agents installed outside this framework. |
| `user_plugins` | string | Comma-joined plugin names from `~/.claude/plugins/installed_plugins.json` with `@marketplace` suffixes stripped. |
| `recent_learnings` | string | Semicolon-joined learning texts from the last 10 JSONL entries |
| `active_specs` | string | Comma-joined `<slug>:<current_group>/<total_groups>` tuples for in-progress specs. Empty if none. Lead agent reads this on its first response and asks whether to resume. |
| `style` | string | Token-efficiency reminder loaded by every agent |
| `external_writes_policy` | string | Instruction for agents to check `ops_enabled` before remote writes |
| `spec_resumption_policy` | string | Instruction for lead to surface `active_specs` on session start |

**Third-party integration discovery is purely observational.** The framework has zero hard dependency on any detected tool or MCP server — bare systems are fully supported. Agents read these fields to surface relevant options alongside the framework's native approach, never to gate framework behavior. See `skills/core/skill-discovery/SKILL.md` → "Tool Awareness" for the agent-side contract.

**Known limitations:**

- Assumes bash 4+ (uses associative arrays and parameter expansion features)
- Malformed JSONL lines in the learnings file are silently skipped
- Language detection runs from the current working directory, not from the project root — the caller is responsible for `cd`-ing into the project

### session-end.sh

**Fires on:** `SessionEnd` event

**What it does:**

1. Reads all buffer files matching `/tmp/claude-learnings-{project-slug}-*`
2. Appends their contents to `~/.claude-resources/learnings/{project-slug}.jsonl`
3. Deletes the buffer files
4. If the persistent JSONL file exceeds 50 lines, prunes it to the last 50 entries

**No output.** Runs silently.

**Known limitations:**

- If the session ends abnormally (crash, kill), buffer files may persist in `/tmp/` until manually cleaned
- 50-line retention is hard-coded; increase by editing the script

### learn.sh

**Fires on:** Manual invocation, either from the `/learn` slash command or directly by an agent via `${CLAUDE_PLUGIN_ROOT}/hooks/learn.sh`.

**What it does:**

1. Validates arguments: learning text (required), category (optional, default `convention`)
2. Rejects categories outside `convention`, `gotcha`, `pattern`, `tool`
3. Resolves the project slug from the git root basename (falls back to `pwd`)
4. Writes one JSONL line to `/tmp/claude-learnings-{project-slug}-{pid}`:

```json
{"learning":"...","category":"...","timestamp":"2026-04-15T12:00:00Z"}
```

5. Prints a confirmation line to stdout

**Usage:**

```bash
./hooks/learn.sh "auth service requires X-Request-ID header"
./hooks/learn.sh "MySQL driver truncates strings >255 chars" "gotcha"
./hooks/learn.sh "use make lint instead of golangci-lint directly" "tool"
```

See [operational-learning.md](operational-learning.md) for the full lifecycle (when to record, what to record, how it surfaces in future sessions).
