#!/bin/sh
# harness-kit example: Claude Code PreToolUse hook (matcher: Bash).
# Blocks plainly destructive git so it goes through a human instead
# (AGENTS.md section 3: "destructive ops need a human").
#
# Contract: tool input arrives as JSON on stdin; exit 2 blocks the call
# and shows stderr to the agent; exit 0 allows it.
set -eu

payload=$(cat)
if command -v jq >/dev/null 2>&1; then
  cmd=$(printf '%s' "$payload" | jq -r '.tool_input.command // empty')
else
  # no jq: match against the raw payload (coarser, still effective)
  cmd=$payload
fi

# The first pattern deliberately catches --force-with-lease too: the canon
# (AGENTS.md section 3) routes ALL force-pushes through a human, lease or not.
# Exempt it here only if your canon says otherwise.
case "$cmd" in
  *"push --force"*|*"push -f"*|*"reset --hard"*|*"branch -D"*|*"clean -fd"*)
    echo "Blocked by harness hook: that is destructive git, and AGENTS.md section 3 says it needs a human yes. Propose it to the user instead of running it." >&2
    exit 2
    ;;
esac
exit 0
