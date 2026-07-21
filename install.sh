#!/bin/sh
# harness-kit installer - drops the starter files into the current repo.
#
#   curl -fsSL https://raw.githubusercontent.com/chocomyong/harness-kit/main/install.sh | sh
#
# - Never overwrites an existing file (prints "skip" instead).
# - Atomic: everything is fetched first; if any fetch fails, nothing is installed.
# - Installs CLAUDE.md only when a .claude/ directory exists (force with HARNESS_CLAUDE=1).
# - Pin a release: HARNESS_KIT_REF=v0.1 (default: main - the kit moves fast pre-1.0).
# - Point HARNESS_KIT_BASE at a fork or a local checkout (file:///path) to install from there.
set -eu

REF="${HARNESS_KIT_REF:-main}"
BASE="${HARNESS_KIT_BASE:-https://raw.githubusercontent.com/chocomyong/harness-kit/$REF}"

command -v curl >/dev/null 2>&1 || { echo "install.sh needs curl" >&2; exit 1; }

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

PLAN=""
stage() {
  # $1 = path inside the kit, $2 = destination in this repo (root-level name)
  if [ -e "$2" ]; then
    echo "skip  $2 (already exists - not overwriting)"
    return 0
  fi
  if ! curl -fsSL "$BASE/$1" -o "$TMP/$2"; then
    echo "FAIL  could not fetch $BASE/$1 - nothing was installed" >&2
    exit 1
  fi
  PLAN="$PLAN $2"
}

if [ -e AGENTS.md ] && grep -q "harness-kit MINIMAL" AGENTS.md; then
  echo "note  your AGENTS.md is the MINIMAL variant - keeping it; the fillable template was NOT installed (see README: MINIMAL vs template)"
else
  stage templates/AGENTS.md      AGENTS.md
fi
stage templates/WORK_PROTOCOL.md WORK_PROTOCOL.md
stage templates/PATTERNS.md      PATTERNS.md

if [ -d .claude ] || [ "${HARNESS_CLAUDE:-0}" = "1" ]; then
  stage templates/CLAUDE.md CLAUDE.md
else
  echo "note  CLAUDE.md not installed (no .claude/ directory - rerun with HARNESS_CLAUDE=1 if you use Claude Code)"
fi

# every fetch succeeded - move into place
for f in $PLAN; do
  mv "$TMP/$f" "./$f"
  echo "add   $f"
done

cat <<'EOT'

Done. Next step (60 seconds): paste this into your coding agent -

  Read AGENTS.md and WORK_PROTOCOL.md. Then survey this repo (file tree,
  git log, existing docs) and fill in every <PLACEHOLDER> in AGENTS.md
  with measured facts about THIS repo. Do not guess: anything you cannot
  verify by reading the repo - especially the top invariant in section 0 -
  ask me instead of inventing it. Show me the diff before saving.

Manual path and details: https://github.com/chocomyong/harness-kit
EOT
