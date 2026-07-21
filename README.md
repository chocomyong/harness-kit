# harness-kit

**The harness for coding agents.** A small set of copy-paste files that keep an AI coding agent honest on a codebase that has to survive.

Not another list of "be concise, write tests." These are operating rules earned the hard way, on a real multi-app repo, across thousands of commits and dozens of production incidents. Scar tissue, not aspiration. ([Where this came from](#where-this-came-from).)

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

## Getting started

harness-kit is not a package you install with one command. It is a set of Markdown files you copy into your own repo and adapt. Adoption is five steps, and none of them takes long.

### 1. Get the files

```bash
# clone it
git clone https://github.com/chocomyong/harness-kit.git

# or grab it without git history
curl -L https://github.com/chocomyong/harness-kit/archive/refs/heads/main.tar.gz | tar xz
```

### 2. Copy the templates you want into your repo

Start small. The one file that matters most is the canon; everything else is optional and additive.

```bash
# the minimum: one canonical rules file at your repo root
cp harness-kit/templates/AGENTS.md ./AGENTS.md

# recommended next
cp harness-kit/templates/WORK_PROTOCOL.md ./docs/WORK_PROTOCOL.md
cp harness-kit/templates/pattern-card.md  ./docs/pattern-card.md   # keep as a format reference
```

### 3. Fill in the blanks

Open `AGENTS.md` and replace every `<PLACEHOLDER>`. Delete sections you do not need. Where to spend your fifteen minutes, in order:

- **Section 0 (top invariant):** the one thing that must never break. If your repo has one, write it first.
- **Section 1 (repo map):** the layout, marking what is live vs. retired.
- **Section 3 (commit contract):** your commit-message format.

A rough canon you actually customized beats a perfect template you copied blindly.

### 4. Wire it to your agent (the step everyone forgets)

A rules file the agent never reads does nothing. Point your agent at it:

| Agent | What to do |
|---|---|
| **Claude Code** | Also copy `templates/CLAUDE.md` to your repo root. Claude Code auto-loads `CLAUDE.md`, which `@import`s your `AGENTS.md`. That is the whole hookup. |
| **Codex / OpenAI** | It reads `AGENTS.md` at the repo root on its own. Nothing else to do. |
| **Cursor** | Cursor reads `AGENTS.md`; or add a one-line `.cursorrules` that says "Follow the rules in AGENTS.md." |
| **Anything else** | Put it in the system prompt or your first message: "Read AGENTS.md and follow it." |

### 5. Confirm it stuck

Ask the agent: *"Summarize the rules in AGENTS.md in five bullets and tell me the top invariant."* If it answers from your file, it is loaded. If it makes something up, it never read it - go back to step 4 and fix the wiring.

> Note: while this repo is private, the `curl` and `git clone` above need your GitHub credentials. Once it is public, they work for anyone.

## Who this is for

- You use an AI coding agent as a **daily driver**, not a toy.
- Your codebase is **long-lived**: it has history, scars, and load-bearing weirdness that "looks wrong but is right."
- You are tired of re-teaching the same lessons every session.
- Bonus: you use **more than one** agent (Claude Code plus Codex, say) and want them to obey the same rules.

If you are writing throwaway scripts, you do not need this. Come back when the code has to survive.

## Where this came from

These rules were not invented at a whiteboard. They were extracted while building and operating **IME (Integrated Monitoring Environment)** - a self-hosted Flask monitoring dashboard that grew to roughly **41,000 lines** of Python, JavaScript, CSS, and templates across **19 route modules** - and the cluster of sibling tools that grew up beside it in the same monorepo: a ranking web board, several notification-watcher daemons, a trading-research harness, a daily-chart crawler. Roughly **ten runnable apps and daemons**, one developer, **~4,500 commits since January 2026**, all deployed to a self-hosted box that had to stay up while the code changed under it.

The `pattern-card.md` format is not hypothetical either: that codebase carries **39 numbered failure patterns**, each one a bug that cost real time and earned its card. The version markers in the worked example (the `v6.7.x` in the 502 case study) are real entries from that log, not invented for illustration.

That is the whole pitch: these rules have receipts. The names, servers, and business details are stripped for privacy, but the scar tissue is genuine - and every number above is measured, not rounded up.

## Prior art and credit

This kit stands on other people's ideas:

- The **fresh-context iteration loop** in `ralph-goal.md` is Geoffrey Huntley's "Ralph" pattern. Read the original: https://ghuntley.com/loop/
- The **`AGENTS.md` convention** for an engine-neutral agent instruction file is a community standard: https://agents.md
- The pre-spec "grill me" thinking that informs `WORK_PROTOCOL.md` owes a debt to Matt Pocock's work on planning with agents.

harness-kit's contribution is not inventing these. It is **wiring them into one coherent operating discipline** and writing down the failure modes that made each rule necessary.

## License

MIT. Take it, fork it, adapt it. If it saves you a bad afternoon, a star is thanks enough.
