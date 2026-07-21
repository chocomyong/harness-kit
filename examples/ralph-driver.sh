#!/bin/sh
# harness-kit: minimal engine-agnostic driver for the fresh-context loop
# (Geoffrey Huntley's "Ralph" pattern - goal file format: templates/ralph-goal.md).
#
# Usage:
#   RALPH_AGENT='claude -p --dangerously-skip-permissions' \
#   RALPH_CHECK='pytest -q' \
#   sh examples/ralph-driver.sh path/to/goal.md [max-iterations]
#
#   RALPH_AGENT  your agent's one-shot CLI; the iteration prompt is passed as
#                its last argument. Examples:
#                  Claude Code:  RALPH_AGENT='claude -p --dangerously-skip-permissions'
#                  Codex CLI:    RALPH_AGENT='codex exec'
#   RALPH_CHECK  the command that PROVES the goal (exit 0 = done). This is the
#                only arbiter - the agent's own "I finished" is never trusted.
#
# Design, in three sentences: each iteration spawns a FRESH agent process, so
# context never accumulates across attempts - every iteration rebuilds its
# understanding from the goal file, git log, and the actual tree. The check
# command, not the agent, decides when it is over. Two consecutive iterations
# without a commit abort the loop as stalled.
#
# Safety, read before running unattended:
# - An unattended loop needs the agent CLI in a non-interactive permission
#   mode, which widens the blast radius. Pair it with the constraints in your
#   goal file and the gates in examples/hooks/, and consider running on a
#   branch or in a separate worktree.
# - When the loop exits, do NOT report success from the exit code alone. Read
#   the log and `git log` yourself, then run an independent review pass over
#   the full commit range (author-is-not-verifier).
set -eu

GOAL="${1:?usage: ralph-driver.sh <goal-file> [max-iterations]}"
MAX="${2:-10}"
: "${RALPH_AGENT:?set RALPH_AGENT to your agent's one-shot CLI (see header)}"
: "${RALPH_CHECK:?set RALPH_CHECK to the command that proves the goal (exit 0 = done)}"
[ -f "$GOAL" ] || { echo "goal file not found: $GOAL" >&2; exit 1; }
git rev-parse --git-dir >/dev/null 2>&1 || { echo "not a git repo - the loop measures progress by commits" >&2; exit 1; }

LOG="ralph-$(date +%Y%m%d-%H%M%S).log"
PROMPT="You are ONE iteration of a fresh-context loop. Read $GOAL and work toward
its acceptance criteria. You have no memory of prior iterations: rebuild your
understanding from the goal file, git log, and the actual file state, and trust
those over any summary you find. Do exactly ONE small unit of work, commit it,
and stop. Never invoke the loop driver yourself. If a criterion is ambiguous,
or the next step is destructive or irreversible, stop and explain instead of
guessing."

check() { sh -c "$RALPH_CHECK" >>"$LOG" 2>&1; }

if check; then
  echo "criteria already met before iteration 1 - nothing to do (log: $LOG)"
  exit 0
fi

stalls=0
i=1
while [ "$i" -le "$MAX" ]; do
  echo "=== iteration $i/$MAX (HEAD $(git rev-parse --short HEAD)) ==="
  before=$(git rev-parse HEAD)
  # The agent's exit status is deliberately ignored: the check is the arbiter.
  sh -c "$RALPH_AGENT \"\$1\"" ralph "$PROMPT" >>"$LOG" 2>&1 || true
  after=$(git rev-parse HEAD)
  if [ "$before" = "$after" ]; then
    stalls=$((stalls + 1))
    echo "    no commit this iteration (stall $stalls/2)"
    if [ "$stalls" -ge 2 ]; then
      echo "ABORT: two consecutive iterations without a commit - stalled or blocked."
      echo "Read $LOG: the agent may be asking for a human decision."
      exit 3
    fi
  else
    stalls=0
    git log --oneline "$before..$after" | sed 's/^/    /'
  fi
  if check; then
    echo "PASS: acceptance check succeeded after iteration $i."
    echo "Do not take this exit code's word for it: read $LOG and git log"
    echo "yourself, then run an independent review before you push."
    exit 0
  fi
  i=$((i + 1))
done

echo "STOP: max iterations ($MAX) reached without passing the check. Read $LOG."
exit 2
