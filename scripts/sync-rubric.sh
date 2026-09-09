#!/usr/bin/env bash
# Vendor the readiness rubric from kaizen-tasks-assembly-line, or check for drift.
#
#   scripts/sync-rubric.sh [ref]             download rubric/readiness.md at <ref> (default develop)
#                                            from GitHub over the local copy, then copy it into
#                                            each skill folder (skills/<name>/readiness.md) so a
#                                            skill uploaded as a ZIP carries its own rubric
#   scripts/sync-rubric.sh --local <path>    copy from a local checkout instead of downloading
#   scripts/sync-rubric.sh --check [ref]     compare the version: lines only; warn on drift; exit 0
#                                            also fails if either in-skill copy differs from
#                                            rubric/readiness.md
#   scripts/sync-rubric.sh --check --local <path>
#
# Engineering owns the rubric. This script only copies it; never edit rubric/readiness.md here.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOCAL_RUBRIC="$REPO_ROOT/rubric/readiness.md"
UPSTREAM_REPO="kpnemo/kaizen-tasks-assembly-line"
UPSTREAM_PATH="rubric/readiness.md"
# Skills carry their own copy of the rubric so a skill uploaded to claude.ai
# as a ZIP of its own folder (no rubric/, no ${CLAUDE_PLUGIN_ROOT}) still has one.
IN_SKILL_RUBRICS=(
  "$REPO_ROOT/skills/refine-request/readiness.md"
  "$REPO_ROOT/skills/synthesize-interviews/readiness.md"
)

check=0
source_path=""
ref="develop"

while [ $# -gt 0 ]; do
  case "$1" in
    --check)
      check=1
      shift
      ;;
    --local)
      source_path="${2:-}"
      if [ -z "$source_path" ]; then
        echo "error: --local needs a path" >&2
        exit 2
      fi
      shift 2
      ;;
    -h | --help)
      sed -n '2,10p' "$0"
      exit 0
      ;;
    -*)
      echo "error: unknown option $1" >&2
      exit 2
      ;;
    *)
      ref="$1"
      shift
      ;;
  esac
done

warn() {
  echo "warning: $1" >&2
  if [ "${GITHUB_ACTIONS:-}" = "true" ]; then
    echo "::warning::$1"
  fi
}

version_of() {
  grep -m1 '^version:' "$1" | sed 's/^version:[[:space:]]*//' | sed -e 's/[[:space:]]*$//' -e "s/^[\"']//" -e "s/[\"']\$//"
}

# The in-skill copies must match rubric/readiness.md exactly (not just by
# version), since that is the file a ZIP upload actually carries. This check
# needs no network access, so it always runs in --check mode and is a hard
# failure, unlike the upstream drift warning (which never fails).
check_in_skill_drift() {
  local status=0
  if [ ! -f "$LOCAL_RUBRIC" ]; then
    echo "error: rubric/readiness.md is missing; run scripts/sync-rubric.sh" >&2
    return 1
  fi
  local skill_rubric name
  for skill_rubric in "${IN_SKILL_RUBRICS[@]}"; do
    name="$(basename "$(dirname "$skill_rubric")")"
    if [ ! -f "$skill_rubric" ]; then
      echo "error: skills/$name/readiness.md is missing; run scripts/sync-rubric.sh" >&2
      status=1
      continue
    fi
    if ! cmp -s "$LOCAL_RUBRIC" "$skill_rubric"; then
      echo "error: skills/$name/readiness.md is out of date; run scripts/sync-rubric.sh" >&2
      status=1
    fi
  done
  return "$status"
}

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

if [ -n "$source_path" ]; then
  if [ ! -f "$source_path" ]; then
    echo "error: $source_path does not exist" >&2
    exit 1
  fi
  cp "$source_path" "$tmp"
  origin="$source_path"
else
  origin="https://raw.githubusercontent.com/$UPSTREAM_REPO/$ref/$UPSTREAM_PATH"
  if ! curl -fsSL "$origin" -o "$tmp"; then
    if [ "$check" -eq 1 ]; then
      warn "rubric drift check skipped: could not download $origin"
      check_in_skill_drift
      exit "$?"
    fi
    echo "error: could not download $origin" >&2
    exit 1
  fi
fi

upstream_version="$(version_of "$tmp" || true)"
if [ -z "$upstream_version" ]; then
  echo "error: no version: line in $origin" >&2
  exit 1
fi

if [ "$check" -eq 1 ]; then
  if [ ! -f "$LOCAL_RUBRIC" ]; then
    warn "rubric/readiness.md is missing locally; upstream is version $upstream_version. Run scripts/sync-rubric.sh"
    check_in_skill_drift
    exit "$?"
  fi
  local_version="$(version_of "$LOCAL_RUBRIC" || true)"
  if [ "$local_version" = "$upstream_version" ]; then
    echo "rubric up to date: version $local_version"
  else
    warn "rubric drift: local version ${local_version:-none}, upstream version $upstream_version. Run scripts/sync-rubric.sh"
  fi
  check_in_skill_drift
  exit "$?"
fi

mkdir -p "$(dirname "$LOCAL_RUBRIC")"
cp "$tmp" "$LOCAL_RUBRIC"
echo "rubric/readiness.md updated to version $upstream_version from $origin"

for skill_rubric in "${IN_SKILL_RUBRICS[@]}"; do
  mkdir -p "$(dirname "$skill_rubric")"
  cp "$LOCAL_RUBRIC" "$skill_rubric"
  echo "${skill_rubric#"$REPO_ROOT"/} updated to version $upstream_version"
done
