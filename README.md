# claude-resources

Multi-language Claude Code agents and skills for production-grade development. Two-tier architecture: **core skills** (language-agnostic principles) + **language skills** (implementation patterns). Currently supports Go, with Angular and other languages planned.

## Architecture

```
skills/
├── core/          # Language-agnostic: decision frameworks, principles, checklists (no code)
└── go/            # Go-specific: code patterns, tool configs, framework usage
    # angular/     # (planned)
    # node/        # (planned)
```

**Token efficiency by design:**
- Core skills: ~50-80 lines each (principles only, no code examples)
- Language skills: ~100-200 lines each (code patterns only, no redundant explanations)
- References lazy-loaded (not included in default skill context)
- Session-start hook detects language, surfaces only relevant skills
- Agents use caveman-style output compression (drop filler, fragments ok)

## Agents

| Agent | Role |
|-------|------|
| **critic** | Analyzes prompts for clarity. ALWAYS runs first. |
| **architect** | Package layout, interfaces, API surface design |
| **builder** | Application code implementation |
| **cli-builder** | CLI implementation |
| **tester** | Test writing and execution |
| **reviewer** | Read-only code review |
| **shipper** | Containerization and observability |
| **lead** | Orchestrates complex multi-agent tasks |

All agents auto-detect project language and load appropriate skills.

## Skills

### Core (language-agnostic)

`error-handling` · `testing` · `code-review` · `api-design` · `concurrency` · `observability` · `docker` · `project-structure` · `style`

### Go

`error-handling` · `testing` · `testing-with-framework` · `concurrency` · `context` · `database` · `interface-design` · `modules` · `style` · `cli` · `api-design` · `observability` · `docker` · `project-init` · `code-review`

## Recommended Tools

For efficient codebase exploration, install these alongside claude-resources:

| Tool | Purpose | Install |
|------|---------|---------|
| **LSP** (native) | Go-to-definition, references, types (~50ms navigation) | `ENABLE_LSP_TOOL=true` + language plugins |
| **ast-grep** | Structural code search (AST patterns, not just regex) | `npm i @ast-grep/cli -g` + skill or MCP server |
| **Codebase-Memory-MCP** | Knowledge graph indexing for large codebases | See [repo](https://github.com/DeusData/codebase-memory-mcp) |

LSP handles navigation. ast-grep handles pattern matching. They're complementary, not redundant.

## Usage

Copy agents and skills into your project's `.claude/` directory, or reference this repo in your Claude Code configuration.

## Adding a New Language

1. Create `skills/<lang>/` with language-specific skill directories
2. Each skill extends a core skill with implementation patterns
3. Update `marketplace.json` to register the new skill group
4. Update `hooks/session-start.sh` to detect the new language

## License

MIT
