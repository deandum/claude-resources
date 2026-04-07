#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_ROOT="$(dirname "$SCRIPT_DIR")"
SKILLS_DIR="$PLUGIN_ROOT/skills"

# Detect project language from current working directory
DETECTED_LANGS=()
[ -f "go.mod" ] && DETECTED_LANGS+=("go")
[ -f "angular.json" ] && DETECTED_LANGS+=("angular")
[ -f "Cargo.toml" ] && DETECTED_LANGS+=("rust")
{ [ -f "pyproject.toml" ] || [ -f "requirements.txt" ]; } && DETECTED_LANGS+=("python")
if [ -f "package.json" ] && [ ! -f "angular.json" ]; then
  DETECTED_LANGS+=("node")
fi

# List available core skills
CORE_SKILLS=""
if [ -d "$SKILLS_DIR/core" ]; then
  CORE_SKILLS=$(find "$SKILLS_DIR/core" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; 2>/dev/null | sort | tr '\n' ', ' | sed 's/,$//')
fi

# List available language skills for detected languages
LANG_SKILLS=""
for lang in "${DETECTED_LANGS[@]+"${DETECTED_LANGS[@]}"}"; do
  if [ -d "$SKILLS_DIR/$lang" ]; then
    skills=$(find "$SKILLS_DIR/$lang" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; 2>/dev/null | sort | tr '\n' ', ' | sed 's/,$//')
    LANG_SKILLS+="$lang: [$skills] "
  fi
done

# Load recent operational learnings for this project
PROJECT_SLUG=$(basename "$(git rev-parse --show-toplevel 2>/dev/null || pwd)")
LEARNINGS_FILE="${HOME}/.claude-resources/learnings/${PROJECT_SLUG}.jsonl"
RECENT_LEARNINGS=""
if [ -f "$LEARNINGS_FILE" ]; then
  RECENT_LEARNINGS=$(tail -10 "$LEARNINGS_FILE" 2>/dev/null | python3 -c "
import sys, json
learnings = []
for line in sys.stdin:
    line = line.strip()
    if not line:
        continue
    try:
        learnings.append(json.loads(line).get('learning', ''))
    except (json.JSONDecodeError, KeyError):
        pass
print('; '.join(l for l in learnings if l))
" 2>/dev/null)
fi

# Check for recommended codebase exploration tools
TOOLS_MISSING=()
command -v ast-grep >/dev/null 2>&1 || TOOLS_MISSING+=("ast-grep")

TOOLS_MSG=""
if [ ${#TOOLS_MISSING[@]} -gt 0 ]; then
  TOOLS_MSG="Missing recommended tools: ${TOOLS_MISSING[*]}. See README for setup."
fi

# Output guidance as valid JSON via python3
python3 -c "
import json, sys
print(json.dumps({
    'priority': 'IMPORTANT',
    'detected_languages': sys.argv[1],
    'core_skills': sys.argv[2],
    'language_skills': sys.argv[3],
    'tools_warning': sys.argv[4],
    'recent_learnings': sys.argv[5],
    'style': 'Apply core/token-efficiency (standard) to human-facing output only. Drop filler, lead with action, fragments ok. Code/commands/paths/specs unchanged.'
}, indent=2))
" \
  "${DETECTED_LANGS[*]+"${DETECTED_LANGS[*]}"}" \
  "$CORE_SKILLS" \
  "${LANG_SKILLS:-none}" \
  "$TOOLS_MSG" \
  "$RECENT_LEARNINGS"
