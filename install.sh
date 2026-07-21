#!/bin/sh
# harness-kit installer - drops the starter files into the current repo.
#
#   curl -fsSL https://raw.githubusercontent.com/chocomyong/harness-kit/main/install.sh | sh
#
# - Never overwrites an existing file (prints "skip" instead).
# - Installs CLAUDE.md only when a .claude/ directory exists (force with HARNESS_CLAUDE=1).
# - Point HARNESS_KIT_BASE at a fork or a local checkout (file:///path) to install from there.
set -eu

BASE="${HARNESS_KIT_BASE:-https://raw.githubusercontent.com/chocomyong/harness-kit/main}"

command -v curl >/dev/null 2>&1 || { echo "install.sh needs curl" >&2; exit 1; }

fetch() {
  # $1 = path inside the kit, $2 = destination in this repo
  if [ -e "$2" ]; then
    echo "skip  $2 (already exists - not overwriting)"
    return 0
  fi
  if curl -fsSL "$BASE/$1" -o "$2"; then
    echo "add   $2"
  else
    echo "FAIL  $2 (could not fetch $BASE/$1)" >&2
    exit 1
  fi
}

fetch templates/AGENTS.md        AGENTS.md
fetch templates/WORK_PROTOCOL.md WORK_PROTOCOL.md
fetch templates/PATTERNS.md      PATTERNS.md

if [ -d .claude ] || [ "${HARNESS_CLAUDE:-0}" = "1" ]; then
  fetch templates/CLAUDE.md CLAUDE.md
else
  echo "note  CLAUDE.md not installed (no .claude/ directory - rerun with HARNESS_CLAUDE=1 if you use Claude Code)"
fi

cat <<'EOT'

Done. Next step (60 seconds): paste this into your coding agent -

  Read AGENTS.md and WORK_PROTOCOL.md. Then survey this repo (file tree,
  git log, existing docs) and fill in every <PLACEHOLDER> in AGENTS.md
  with measured facts about THIS repo. Do not guess: anything you cannot
  verify by reading the repo - especially the top invariant in section 0 -
  ask me instead of inventing it. Show me the diff before saving.

Manual path and details: https://github.com/chocomyong/harness-kit
EOT
