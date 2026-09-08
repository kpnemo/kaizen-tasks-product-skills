#!/usr/bin/env bash
# Verify every skills/*/SKILL.md starts with YAML front matter that has
# name and description, and that name equals the folder name.
# Exit 1 with FAIL lines on any problem; exit 0 with one ok line per skill.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

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
  if [ "$bad" -eq 0 ]; then
    echo "ok: $f ($name)"
  else
    status=1
  fi
done
exit "$status"
