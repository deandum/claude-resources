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
[ -f "pyproject.toml" ] || [ -f "requirements.txt" ] && DETECTED_LANGS+=("python")
if [ -f "package.json" ] && [ ! -f "angular.json" ]; then
  DETECTED_LANGS+=("node")
fi

# List available core skills
CORE_SKILLS=""
if [ -d "$SKILLS_DIR/core" ]; then
  CORE_SKILLS=$(ls "$SKILLS_DIR/core/" 2>/dev/null | tr '\n' ', ' | sed 's/,$//')
fi

# List available language skills for detected languages
LANG_SKILLS=""
for lang in "${DETECTED_LANGS[@]}"; do
  if [ -d "$SKILLS_DIR/$lang" ]; then
    skills=$(ls "$SKILLS_DIR/$lang/" 2>/dev/null | tr '\n' ', ' | sed 's/,$//')
    LANG_SKILLS+="$lang: [$skills] "
  fi
done

# Check for recommended codebase exploration tools
TOOLS_MISSING=()
command -v ast-grep >/dev/null 2>&1 || TOOLS_MISSING+=("ast-grep")

TOOLS_MSG=""
if [ ${#TOOLS_MISSING[@]} -gt 0 ]; then
  TOOLS_MSG="Missing recommended tools: ${TOOLS_MISSING[*]}. See README for setup."
fi

# Output guidance
cat <<EOF
{
  "priority": "IMPORTANT",
  "detected_languages": "${DETECTED_LANGS[*]:-unknown}",
  "core_skills": "$CORE_SKILLS",
  "language_skills": "${LANG_SKILLS:-none}",
  "tools_warning": "$TOOLS_MSG",
  "style": "concise — drop filler, lead with action, fragments ok. Code and technical terms use normal English."
}
EOF
