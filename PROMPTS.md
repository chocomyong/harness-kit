# PROMPTS.md - copy-paste prompts for the whole lifecycle

The kit's files talk to your **agent**. This file talks to **you**: ready-made prompts for the moments where the harness earns its keep. Every block is paste-ready; replace only the `<angle-bracket>` parts.

---

## 1. Set up (the bootstrap)

Right after `install.sh` - or any time placeholders remain in your canon:

```text
Read AGENTS.md and WORK_PROTOCOL.md. Then survey this repo (file tree,
git log, existing docs) and fill in every <PLACEHOLDER> in AGENTS.md
with measured facts about THIS repo. Do not guess: anything you cannot
verify by reading the repo - especially the top invariant in section 0 -
ask me instead of inventing it. Show me the diff before saving.
```

## 2. Check the rules are actually loaded

Start of any session, or whenever the agent's behavior smells unharnessed:

```text
Summarize the rules in AGENTS.md in five bullets and tell me the top
invariant, quoting the exact line.
```

If it answers from your file, it is loaded. If it makes something up, the wiring is broken - fix that before doing any work (see "Wire it to your agent" in the README).

## 3. Start a piece of real work

Before a feature, fix, or refactor - this fires the bootstrap discipline from WORK_PROTOCOL section 0:

```text
We are about to work on: <one-line description>.
Read AGENTS.md and WORK_PROTOCOL.md. Check the index in PATTERNS.md for
cards that touch this area, open those cards, and name the relevant
ones. Then state your plan in one paragraph - files to change, blast
radius, risk - before editing anything.
```

## 4. Record what a bug just taught you

The moment a debugging session ends is the moment the knowledge is cheapest to capture:

```text
We just finished debugging: <one-line summary>.
Write a pattern card for PATTERNS.md: symptom (what we actually saw),
debug path (what we checked, in order, including the dead ends), root
cause (two sentences max), and a concrete checkable prevention rule -
"be careful" does not count. Number it next in sequence, date it, and
show me the card before saving.
```

## 5. Challenge an absence claim

When the agent says "X does not exist," "that is dead code," or "there is no backup" - before you act on it:

```text
You claimed: <the absence claim>.
Before we act on that: search for it under other names and spellings,
check whether the logic moved to another module instead of dying, and
list every place you looked. Presence needs one example; absence needs
an exhaustive check. If you cannot do the exhaustive check, say
"could not confirm either way" - do not restate the absence.
```

(Why this matters enough to have its own prompt: [`principles/absence-judgment.md`](principles/absence-judgment.md).)

## 6. Review before commit (author-is-not-verifier)

After a batch of changes, ideally in a fresh session or a subagent so the reviewer does not share the author's blind spot:

```text
Act as an independent reviewer with fresh eyes; you did not write this.
Read the full staged diff. Check it against AGENTS.md - especially the
top invariant and the commit contract - and against the PATTERNS.md
cards for the touched areas. Report blocking findings first, then
nitpicks. If the diff includes files the stated goal does not require,
flag them.
```

## 7. Absorb the kit into an existing rules system

If your repo already runs its own rules docs (a `CLAUDE.md`, a dev guide, house protocols), do not install a parallel system - the same rule stated in two places drifts (this repo's own PATTERN-01). Absorb instead:

```text
Read harness-kit's MINIMAL.md and principles/absence-judgment.md
(github.com/chocomyong/harness-kit). Then read our existing rules docs.
Do NOT create new rule files or a second rules system. Propose the
smallest set of edits that folds, INTO our existing docs and in their
language and format: (1) an index-first incident registry seeded with
the rules we already re-explain or re-litigate, (2) absence-judgment as
a named rule, (3) our top invariant stated at the top of our
highest-authority doc. Where a kit idea duplicates something we already
have, keep ours and skip the kit's. Show me the diff before saving.
```

## 8. Keep the canon current

Monthly, or after a big refactor - a canon that drifts from the repo becomes noise:

```text
The canon was last filled around <date>. Survey what has changed since:
git log since then, new modules, moved or retired code. Propose updates
to AGENTS.md - repo map rows, naming, stale rules - from measured facts
only. Show me the diff; do not weaken the top invariant or delete rules
you merely do not understand (ask instead).
```

---

*These prompts are starting points - once a phrasing works for your team, pin your version of it here in your own copy. This file is part of [harness-kit](https://github.com/chocomyong/harness-kit), MIT.*
