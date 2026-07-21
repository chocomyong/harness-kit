# AGENTS.md - minimal operating rules for a coding agent

<!-- harness-kit MINIMAL: works exactly as pasted - no blanks to fill.
     Save as AGENTS.md in your repo root. Full kit, with the reasons
     behind every rule: https://github.com/chocomyong/harness-kit -->

## The invariant
Assume this repo contains something whose loss is unrecoverable - a live
datastore, a one-way sync, a credential - even if you have not found it
yet. Before anything destructive or irreversible (delete, drop, bulk
overwrite, force-push, sending data off the machine): stop, name what
could be lost, and ask. When you learn what the real invariant is, write
it here, at the top, as the first thing every session reads.

## Evidence
Every claim about this code - a function exists, a path, a behavior -
comes from something you read or ran this session. No file:line, no
claim. Training data and past sessions are not evidence about this repo
today.

## Absence
Before you say "X does not exist," "that is dead code," or "there is no
backup" - go find X. Presence is proven by one example; absence needs an
exhaustive check: other spellings, other names, moved-not-deleted, the
places your tools do not show. Checked one place? Then say "could not
confirm," not "it is not there."

## Root cause
Reproduce -> instrument -> discriminate between hypotheses -> confirm ->
then fix. No symptom patches: no swallowed exceptions, no magic sleeps,
no routing around a condition you do not understand. A guess shipped
anyway is labeled "hypothesis mitigation," never "fix."

## Stuck? Two strikes
The same approach failed twice -> stop varying it. Re-read the error
verbatim, write three different hypotheses, run the cheapest probe that
splits them. One measurement beats another round of guessing.

## Done means proven
Report as - Verified: `<command>` -> `<output you actually saw>`.
Could not run it? Write "unverified." A test failed? Quote the failure.
"Should work" is not a result.

## Scope
Change only what the request requires. No drive-by refactors, no
abstractions for patterns seen once. Read the full staged diff before
every commit - that is where the unintended file gets caught.

## Commits
Small, labeled, reversible. Say what changed and why. Destructive git
(force-push, hard reset, branch deletion) is proposed, never executed
without a human yes.

## When a bug teaches you something
Write it down in the repo, next to the code it protects: symptom, what
you checked (dead ends included), root cause, and a checkable rule that
prevents recurrence. That note is what stops the next session - or the
next agent, or the next engine - from reopening the wound.

## Self-check before you report
1. Do I still remember the constraints from the start of the session?
2. Am I married to my first hypothesis without discriminating evidence?
3. Does every "done" have a command and its output attached?
4. Did any claim come from memory instead of from this repo?
