#!/usr/bin/env bash
# Verify every skills/*/SKILL.md starts with YAML front matter that has
# name and description, that name equals the folder name, and that no
# front matter key falls outside the set claude.ai accepts on upload
# (Customize > Skills > + Create skill rejects any other key with
# "Unexpected key(s) in SKILL.md frontmatter").
# Exit 1 with FAIL lines on any problem; exit 0 with one ok line per skill.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

# The only front-matter fields claude.ai's skill upload accepts.
ALLOWED_KEYS=(name description license compatibility metadata allowed-tools)

is_allowed_key() {
  local key="$1"
  for allowed in "${ALLOWED_KEYS[@]}"; do
    if [ "$key" = "$allowed" ]; then
      return 0
    fi
  done
  return 1
}

shopt -s nullglob
files=(skills/*/SKILL.md)
if [ "${#files[@]}" -eq 0 ]; then
  echo "FAIL: no skills found under skills/"
  exit 1
fi

status=0
for f in "${files[@]}"; do
  bad=0
  dir="$(basename "$(dirname "$f")")"
  if [ "$(head -n1 "$f")" != "---" ]; then
    echo "FAIL: $f does not start with front matter"
    status=1
    continue
  fi
  # Lines between the first '---' and the next '---'.
  fm="$(awk 'NR==1 {next} /^---$/ {exit} {print}' "$f")"
  name="$(printf '%s\n' "$fm" | sed -n 's/^name:[[:space:]]*//p' | head -n1)"
  desc="$(printf '%s\n' "$fm" | sed -n 's/^description:[[:space:]]*//p' | head -n1)"
  if [ -z "$name" ]; then
    echo "FAIL: $f has no name in its front matter"
    bad=1
  elif [ "$name" != "$dir" ]; then
    echo "FAIL: $f name '$name' does not match folder '$dir'"
    bad=1
  fi
  if [ -z "$desc" ]; then
    echo "FAIL: $f has no description in its front matter"
    bad=1
  fi
  # Top-level keys are unindented lines of the form "key:"; nested/list
  # content under a key is indented and is not itself a key to check.
  while IFS= read -r key; do
    [ -z "$key" ] && continue
    if ! is_allowed_key "$key"; then
      echo "FAIL: $f has disallowed front matter key '$key' (claude.ai upload only accepts: ${ALLOWED_KEYS[*]})"
      bad=1
    fi
  done < <(printf '%s\n' "$fm" | sed -n 's/^\([A-Za-z][A-Za-z0-9_-]*\):.*/\1/p')
  if [ "$bad" -eq 0 ]; then
    echo "ok: $f ($name)"
  else
    status=1
  fi
done
exit "$status"
