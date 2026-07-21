# WORK_PROTOCOL.md - how to think while working

> The canon (`AGENTS.md`) says *what* the rules are. This says *how to reason* while applying them. Both apply at once; neither replaces the other.
>
> Why a checklist and not "just be careful": explicit checklists measurably raise an agent's real performance. Do not skip a step because it "looks obvious." Every step below is here because skipping it caused a specific, documented failure.
>
> Scope: substantial work (features, bug fixes, refactors, debugging, deploys). Skip for trivial one-line edits and conversation.

## 0. Bootstrap - before touching anything (a fixed 5-minute cost)

Order matters. Skip one and every step after it is built on sand.

1. **Scope it.** Which app or module? Load *its* docs first, not the repo's front page.
2. **Locate by looking, not remembering.** Grep and read the actual files. If your repo has an interface registry or a module map, read that first.
3. **Check the registry's index.** Open the cards it names for your area and cite them in your plan - index first, do not re-read every card.
4. **Get recent context.** Last ~10 commits plus the relevant changelog top. The previous loop's output is this loop's input.
5. **State the plan, then execute.** Files to change, blast radius, risk - one paragraph. For anything irreversible, confirming the guard is a precondition of starting.

## 1. Evidence first - no coding from memory

- Every claim about the code (a function exists, its signature, a path, a behavior) must come from something you **read or grepped this session**. A claim you cannot anchor to `file:line` gets deleted or verified before it ships.
- Training data and past sessions are not evidence about *this* repo *today*. Files get moved and deleted. Confirm before referencing.
- Run independent reads in parallel. Delegate broad searches and take back only the conclusion.

## 2. Hold the whole problem before editing

- Read the request to the end. Restate the goal in one sentence. List the constraints (shared modules, deploy path, data risk). *Then* make the first edit. Do not start editing having read 20% of the ask.
- Big instructions get decomposed into phases. Verify and commit per phase, then stop. Checkpoints beat one giant dump.

## 3. Root cause before fix - no fix without a cause

The most expensive failure mode in agent-assisted work is patching before understanding. A real example from the repo this kit came from: a site-down incident where fixes were shipped before the cause was known burned **eighteen versions** before anyone found the actual two-line root cause.

Procedure: **reproduce -> instrument (log/probe) -> discriminating hypothesis -> confirm cause -> fix.**

- If you cannot reproduce or confirm, say so. If you ship a guess anyway, label it "hypothesis mitigation," not "fix."
- No symptom patches: swallowing an exception, a random `sleep`, routing around a condition. If the real cause is a separate job, defend the symptom AND file the cause as its own ticket, and say you did.

## 4. Verify, then report - kill "done" (when it is not)

No completion claim without evidence. Minimum proof by change type:

| Change | Minimum verification |
|---|---|
| Code change | the import/build/lint command actually run, output quoted |
| Schema change | the schema test suite passing |
| Large JS/CSS edit | grep every renamed or deleted class/selector for stragglers |
| Deploy | read the deployed build's version marker and the boot log, do not assume |

Report as: **"Verified: `<command>` -> `<quoted output>`."** If you could not run it, write "unverified." If a test failed, report the failure with its output. Do not hide it, do not smooth it over.

## 5. Stuck protocol - the two-strike rule

If the same approach fails twice, do not try a third variation. Instead:

1. Re-read the error message **verbatim** (yours, not your paraphrase of it).
2. Write down three *different* hypotheses, explicitly.
3. Run the cheapest probe that tells them apart (one log line, a diagnostic script, a standalone repro) *before* changing more code.

One measurement is always cheaper than another round of guessing.

## 6. Scope discipline - surgical changes

- Simplicity first. No refactor, helper, option, or toggle that the request does not require. Do not abstract until you have seen the same pattern three times.
- Read `git diff --staged` in full before every commit. That is where the unintended file - and the invariant violation - gets caught.

## 7. Absence-judgment - "X does not exist" is expensive

Before you write "there is no X" / "that is dead" / "there is no backup," **go find X.** A claim of absence needs more evidence than a claim of presence: presence is proven by one instance, absence requires an exhaustive check. If you looked in one place (one variable, one filename, one grep) and concluded "not there," that is not a judgment, it is a guess. "Not on my screen" is not "does not exist."

Corollary: if the only reason you believe X is absent is that a dashboard or log does not show it, you have found an **observation gap**, not an absence - and the gap itself is usually worth fixing, because the next person will make the same misjudgment.

This one has its own essay because it is the sharpest and most common failure: `principles/absence-judgment.md`. Read it.

## 8. Self-check before you commit or report - four questions

Long sessions erode discipline. Ask these before every commit and every report:

1. **Do I still remember the constraints from the start of the session?** (commit format, the invariant, the house style) They evaporate over a long session.
2. **Am I still married to my first hypothesis?** If a cause is "confirmed" with no discriminating evidence, go back to section 3.
3. **Does my "done" have evidence attached?** If not, run the check or say "unverified."
4. **Did I pull any answer from memory?** Any `file:line`-less claim gets deleted or verified.
