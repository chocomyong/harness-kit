# Goal template - fresh-context iteration loop

> For "run until it passes" work: repeated attempts against a clear finish line, where a single long context would accumulate drift and hallucination. This is Geoffrey Huntley's "Ralph" pattern - an external driver spawns a **fresh agent process each iteration**, so context never accumulates. Each iteration rebuilds its understanding from `git log` and the actual file state, not from a memory that could be wrong. Original write-up: https://ghuntley.com/loop/
>
> Write one goal file, point your loop driver at it, and let it run. The driver re-invokes a fresh agent per iteration until the acceptance criteria are met or a max-iteration cap is hit. A minimal, engine-agnostic driver ships in [`examples/ralph-driver.sh`](../examples/ralph-driver.sh) - bring your own agent CLI; the check command, not the agent, decides when it is done.

## When this pays off (and when it does not)

Each iteration reloads the full system prompt and canon, so a loop costs roughly **5x the tokens** of a single pass. It is worth it only when:

- The finish line is **machine-checkable** ("tests pass," "build succeeds," "this grep returns zero").
- A first attempt is unlikely to nail it (real iteration value).
- The work runs unattended and you want it to self-correct without you babysitting.

It is a waste on: a single clear edit, a trivial fix, or a question. For those, one pass is 5x cheaper. Do not reach for the loop just because it feels thorough.

## The goal file

```markdown
# Goal: <short title>

## Acceptance criteria
- [ ] <a condition a machine can check - not "make it better">
- [ ] <e.g. `pytest` exits 0>
- [ ] <e.g. `grep -r "<forbidden pattern>" src/` returns nothing>
- [ ] <e.g. the build command produces an artifact and exits 0>

## Constraints
- Do NOT <the destructive things: file deletion, schema drop, force-push - escalate these to a human instead of doing them>
- Do NOT re-invoke the loop driver (prevents recursive spawning)
- Keep <the invariant from AGENTS.md section 0> safe
- One iteration = one commit (small rollback unit)

## References
- Relevant files: <paths>
- Relevant docs: <paths>
- Relevant pattern cards: <PATTERN-NN, ...>
```

## Writing acceptance criteria that actually terminate

- **No vague finish lines.** "Make it cleaner" makes the loop run forever or quit arbitrarily. Every criterion must be externally checkable.
- **Prefer commands over prose.** "`npm test` passes" beats "tests should work." The driver can verify the former.
- If a criterion is ambiguous, a good loop should stop and ask rather than guess its way to a false victory.

## Safety, and verifying after it stops

- Bake the destructive-op escalation and the no-recursion rule into every goal file, as above.
- When the loop exits, **do not report success from the exit code alone.** Read the loop's log and the actual `git log` yourself. The per-iteration fresh-context protection covers the iterations; your final summary is a single pass and can still hallucinate.
- After a successful loop, run the independent review pass (author-is-not-verifier) over the full commit range before you push.
