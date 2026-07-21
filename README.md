# harness-kit

**The harness for coding agents.** A small set of copy-paste files that keep an AI coding agent honest on a codebase that has to survive.

Not another list of "be concise, write tests." These are operating rules earned the hard way, on a real multi-app repo, over a year of production incidents. Scar tissue, not aspiration.

---

## The problem this solves

If you have used a coding agent on a real, long-lived codebase, you have seen all of these:

- It **forgets the rules** three sessions in, and re-introduces a bug you already fixed.
- It **"improves" a safety pattern out of existence** because the reason it was there lived in your head, not in the code.
- It **confidently tells you something does not exist** ("there is no backup", "that function is dead") when it is right there, one grep away.
- It **patches the symptom** and calls it a fix, then the same failure returns under a new disguise.
- It **declares victory without evidence** ("done!") and the thing does not actually work.

None of these are model-intelligence problems. They are **harness** problems: the agent has no durable place to keep what it learned, no discipline to check itself, and no structure that stops it from undoing your safety work. harness-kit is that missing layer.

## What is in the box (v0.1)

Copy the templates into your own repo and fill in the blanks. Each is standalone.

| File | What it gives you |
|---|---|
| [`templates/AGENTS.md`](templates/AGENTS.md) | An **engine-neutral canon**: one source-of-truth rules file every agent reads, so Claude Code, Codex, and the next tool you adopt stay in sync instead of drifting. |
| [`templates/CLAUDE.md`](templates/CLAUDE.md) | A **thin engine appendix** that imports the canon and holds only the Claude-Code-specific machinery (skills, subagents, hooks). The pattern that keeps rules DRY across engines. |
| [`templates/WORK_PROTOCOL.md`](templates/WORK_PROTOCOL.md) | The **thinking discipline**: evidence-first, root-cause-before-fix, a two-strike rule for when you are stuck, and a four-question self-check before you dare say "done." |
| [`templates/pattern-card.md`](templates/pattern-card.md) | A **4-block incident card** (symptom / debug path / root cause / prevention). This is how you stop the agent from re-deleting a fix: you move the reason out of your head and into the repo. |
| [`templates/ralph-goal.md`](templates/ralph-goal.md) | A goal template for **fresh-context iteration loops** (the "run until it passes" pattern), with the acceptance criteria written so a machine can check them. |

Plus one essay, because it is the sharpest idea here and worth reading before you touch anything else:

- [`principles/absence-judgment.md`](principles/absence-judgment.md) - **The failure mode nobody warns you about: agents confidently telling you things do not exist.** Why "X does not exist" is a far more expensive claim than "X exists," and the four rules that stop it from wrecking your day.

More principles and anonymized case studies land in v0.2 if this is useful to people. Tell me by starring or opening an issue.

## Quick start

```bash
# from the root of the repo you want to harness
curl -L https://github.com/chocomyong/harness-kit/archive/refs/heads/main.tar.gz | tar xz
cp harness-kit-main/templates/AGENTS.md ./AGENTS.md
cp harness-kit-main/templates/WORK_PROTOCOL.md ./docs/WORK_PROTOCOL.md
# if you use Claude Code, also:
cp harness-kit-main/templates/CLAUDE.md ./CLAUDE.md
```

Then open `AGENTS.md` and replace every `<PLACEHOLDER>`. Delete the sections you do not need. The point is not to adopt all of it - it is to have a canon at all, and to make the agent read it.

## Who this is for

- You use an AI coding agent as a **daily driver**, not a toy.
- Your codebase is **long-lived**: it has history, scars, and load-bearing weirdness that "looks wrong but is right."
- You are tired of re-teaching the same lessons every session.
- Bonus: you use **more than one** agent (Claude Code plus Codex, say) and want them to obey the same rules.

If you are writing throwaway scripts, you do not need this. Come back when the code has to survive.

## Prior art and credit

This kit stands on other people's ideas:

- The **fresh-context iteration loop** in `ralph-goal.md` is Geoffrey Huntley's "Ralph" pattern. Read the original: https://ghuntley.com/loop/
- The **`AGENTS.md` convention** for an engine-neutral agent instruction file is a community standard: https://agents.md
- The pre-spec "grill me" thinking that informs `WORK_PROTOCOL.md` owes a debt to Matt Pocock's work on planning with agents.

harness-kit's contribution is not inventing these. It is **wiring them into one coherent operating discipline** and writing down the failure modes that made each rule necessary.

## License

MIT. Take it, fork it, adapt it. If it saves you a bad afternoon, a star is thanks enough.
