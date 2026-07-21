# Adoption, end to end - a five-minute walkthrough

> This is not a hypothetical. Before writing it down, we walked this exact path against the live kit: a fresh throwaway repo, the real installer from `main`, the real bootstrap prompt. The outputs below are what actually happened (the project is a stand-in, invented for the test).

## The starting point

A tiny personal project - an expense logger. One source file, one README, and one fact that matters more than everything else in the repo combined:

```
expense-tracker/
├── README.md          "data/expenses.db is the only copy of my records."
├── src/tracker.py     (sqlite logger, ~10 lines)
└── data/
```

No rules files, no harness. An agent working here today knows none of this - including the part about the only copy.

## Step 1 - install (about ten seconds)

From the repo root:

```console
$ curl -fsSL https://raw.githubusercontent.com/chocomyong/harness-kit/main/install.sh | sh
add   AGENTS.md
add   WORK_PROTOCOL.md
add   PATTERNS.md
note  CLAUDE.md not installed (no .claude/ directory - rerun with HARNESS_CLAUDE=1 if you use Claude Code)

Done. Next step (60 seconds): paste this into your coding agent -
...
```

Three files appear. Nothing existing was touched.

## Step 2 - the agent fills its own canon

Paste the bootstrap prompt (the installer just printed it) into your agent. The agent surveys the repo - file tree, `git log`, the README - and proposes values for every blank. The interesting part is section 0. Before:

```markdown
**`<INVARIANT>`.** Before any work that could touch it, `<the guard you must confirm first>`.
```

After - filled from a **measured fact**, with the source cited:

```markdown
**`data/expenses.db` is the only copy of the expense records (README.md line 3).**
Before any work that touches `data/` or the schema in `src/tracker.py`, confirm a
dated backup copy of the db exists and say so in the plan.
```

The agent did not invent that. It read the README, recognized "the only copy" as invariant material, and anchored the rule to the line it came from. Anything it could not verify, the prompt obliges it to ask about instead. You review the diff, confirm the invariant, and it commits:

```console
$ git log --oneline -1
chore: adopt harness-kit canon
```

## What is different now

The next session - any engine, any day - opens on a repo that says, before anything else: *there is a file here whose loss is unrecoverable, and here is the guard.* Concretely:

- Ask the agent to "clean up the data directory" and it must stop at the section-0 guard instead of obliging.
- Ask it whether there is a backup and it owes you an exhaustive check, not a glance ([why that matters](../principles/absence-judgment.md)).
- The first real bug becomes `PATTERNS.md` card 01, and every later plan that touches that area must cite it.

Total cost: one command, one pasted prompt, one confirmation. The walkthrough above, performed for real, took about five minutes end to end.

## Where to go next

- [`AGENTS.example.md`](AGENTS.example.md) - a bigger filled canon (multi-component project), showing what yours grows into.
- [`PROMPTS.md`](../PROMPTS.md) - paste-ready prompts for the rest of the lifecycle: session start, pattern cards, absence checks, pre-commit review, canon upkeep.
