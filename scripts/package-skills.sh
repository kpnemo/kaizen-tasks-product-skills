#!/usr/bin/env bash
# Package each skills/<name>/ folder as dist/<name>.zip for upload to
# claude.ai (Customize > Skills > + Create skill), Claude Desktop, or Cowork.
#
# Each ZIP contains the skill folder itself at the ZIP root, so it unpacks
# to <name>/SKILL.md and <name>/readiness.md (the rubric copy that travels
# with the skill, since a ZIP upload has neither ${CLAUDE_PLUGIN_ROOT} nor
# the project root's rubric/readiness.md).
#
#   scripts/package-skills.sh
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

SKILLS_DIR="$REPO_ROOT/skills"
DIST_DIR="$REPO_ROOT/dist"

shopt -s nullglob
skill_dirs=("$SKILLS_DIR"/*/)
if [ "${#skill_dirs[@]}" -eq 0 ]; then
  echo "error: no skills found under skills/" >&2
  exit 1
fi

mkdir -p "$DIST_DIR"

# Delete stale zips first so a removed or renamed skill doesn't leave a
# dist/ file behind that no longer matches skills/.
rm -f "$DIST_DIR"/*.zip

for dir in "${skill_dirs[@]}"; do
  name="$(basename "$dir")"
  zip_path="$DIST_DIR/$name.zip"

  # zip -r from inside skills/ so the skill folder itself is the ZIP root
  # entry (unzips to <name>/SKILL.md, <name>/readiness.md, ...).
  (cd "$SKILLS_DIR" && zip -r -q "$zip_path" "$name")

  size="$(du -h "$zip_path" | cut -f1 | tr -d '[:space:]')"
  echo "$zip_path ($size)"
done
