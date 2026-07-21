# harness-kit

**The harness for coding agents.** A small set of copy-paste files that keep an AI coding agent honest on a codebase that has to survive.

Not another list of "be concise, write tests." These are operating rules earned the hard way, on a real multi-app repo, across thousands of commits and dozens of production incidents. Scar tissue, not aspiration. ([Where this came from](#where-this-came-from).)

---

## Quickstart (60 seconds)

> **If you are a coding agent sent here with "set this up in my repo":** this README is your instruction set - do not just summarize it back. Run step 1's installer in the user's repo root, then perform step 2's survey-and-fill yourself, and show the user the diff before saving. If the repo already has its own rules docs, use the absorb path in the FAQ instead of installing a second system.

**One paste, and your agent does the whole onboarding.** Open your coding agent (Claude Code, Codex, Cursor - anything that can run shell commands) in your repo and paste the block below. You do not need to know what the commands do; the agent runs them, and asks you before anything it cannot verify.

```text
Set up harness-kit in this repo:

1. Run:
   curl -fsSL https://raw.githubusercontent.com/chocomyong/harness-kit/main/install.sh | sh
   (it only adds files; it never overwrites anything that already exists)

2. Read the AGENTS.md and WORK_PROTOCOL.md it installed. Then survey this
   repo (file tree, git log, existing docs) and fill in every <PLACEHOLDER>
   in AGENTS.md with measured facts about THIS repo. Do not guess: anything
   you cannot verify by reading the repo - especially the top invariant in
   section 0 - ask me instead of inventing it. Show me the diff before saving.
```

**What you get when it finishes:**

- **Your repo carries its own operating rules.** `AGENTS.md` (the rules), `WORK_PROTOCOL.md` (the thinking discipline), `PATTERNS.md` (the incident registry) live in your repo, so every future session - any engine - starts from them instead of from zero. You stop re-teaching the same lessons.
- **The agent works under discipline**: evidence before claims, root cause before fix, a human sign-off before anything destructive, and a self-check before it is allowed to say "done."
- **Bugs stop coming back.** Each one that teaches you something becomes a numbered card in `PATTERNS.md` that future sessions must read before touching that area - which is what stops an agent from "cleaning up" a fix it does not understand.

**Pick your depth:**

| Time | Path |
|---|---|
| 30 seconds | [`MINIMAL.md`](MINIMAL.md) - the whole discipline in 64 lines, zero blanks. Save as `AGENTS.md`, done. |
| 60 seconds | The quickstart above - installer plus your agent filling a repo-specific canon. |
| 5 minutes | [`examples/walkthrough.md`](examples/walkthrough.md) - watch the whole journey, real outputs, before running anything. |
| 20 minutes | Read every word. The whole kit is ~650 lines of Markdown; density is the feature. |

Pick **one** path for `AGENTS.md` - MINIMAL as-is, *or* the fillable template via the installer (if MINIMAL is already in place, `install.sh` keeps it and says so). If piping curl into a shell makes you itch - it should - [`install.sh`](install.sh) is 50 lines of plain POSIX sh that only ever adds files; read it first. Either way the templates are safe before customization: an unfilled canon defaults to "assume an invariant you cannot see exists; ask before anything destructive." The agent assembling its own harness from measured facts is not a gimmick - it is the kit's first lesson in practice: **measured, not guessed.**

After day one, [`PROMPTS.md`](PROMPTS.md) has a paste-ready prompt for each lifecycle moment; [Getting started](#getting-started) below unrolls the adoption by hand.

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

Copy the templates into your own repo and fill in the blanks. Each is standalone; the whole kit is a small set of load-bearing rules, not a framework.

| File | What it gives you |
|---|---|
| [`MINIMAL.md`](MINIMAL.md) | **The 64-line harness.** The whole discipline distilled into one file with zero blanks - save it as `AGENTS.md` and it works exactly as pasted. |
| [`templates/AGENTS.md`](templates/AGENTS.md) | An **engine-neutral canon**: one source-of-truth rules file every agent reads, so Claude Code, Codex, and the next tool you adopt stay in sync instead of drifting. |
| [`templates/CLAUDE.md`](templates/CLAUDE.md) | A **thin engine appendix** that imports the canon and holds only the Claude-Code-specific machinery (skills, subagents, hooks). The pattern that keeps rules DRY across engines. |
| [`templates/WORK_PROTOCOL.md`](templates/WORK_PROTOCOL.md) | The **thinking discipline**: evidence-first, root-cause-before-fix, a two-strike rule for when you are stuck, and a four-question self-check before you dare say "done." |
| [`templates/pattern-card.md`](templates/pattern-card.md) | A **4-block incident card** (symptom / debug path / root cause / prevention). This is how you stop the agent from re-deleting a fix: you move the reason out of your head and into the repo. |
| [`templates/PATTERNS.md`](templates/PATTERNS.md) | A **drop-in seed for the incident registry** - the file the cards accumulate in. The installer places it at your repo root, ready for card 01. |
| [`templates/ralph-goal.md`](templates/ralph-goal.md) | A goal template for **fresh-context iteration loops** (the "run until it passes" pattern), with the acceptance criteria written so a machine can check them. |
| [`examples/ralph-driver.sh`](examples/ralph-driver.sh) | A **minimal engine-agnostic loop driver** for that template: fresh agent process per iteration, a check command as the only arbiter, stall detection. Bring your own agent CLI. |
| [`install.sh`](install.sh) | The **one-command installer**: copies the files above into your repo, skips anything that already exists, detects Claude Code, prints the bootstrap prompt. |
| [`examples/AGENTS.example.md`](examples/AGENTS.example.md) | The canon **filled in end-to-end** for a fictional multi-component project - deliberately bigger than the walkthrough's single-file tracker: that one shows adoption, this one shows what your canon grows into. |
| [`examples/walkthrough.md`](examples/walkthrough.md) | **Adoption end to end in five minutes** - a real walkthrough of install -> agent fill -> what changes, with the actual outputs. |
| [`examples/hooks/`](examples/hooks/) | **Enforcement, not just prose**: a git pre-commit that blocks the section-0 invariant file from being staged, and a Claude Code hook that stops destructive git. Optional, engine-labeled. |
| [`PROMPTS.md`](PROMPTS.md) | **Paste-ready prompts for the whole lifecycle**: bootstrap, session start, recording a pattern card, challenging an absence claim, pre-commit review, absorbing into existing rules, canon upkeep. |

Plus one essay, because it is the sharpest idea here and worth reading before you touch anything else:

- [`principles/absence-judgment.md`](principles/absence-judgment.md) - **The failure mode nobody warns you about: agents confidently telling you things do not exist.** Why "X does not exist" is a far more expensive claim than "X exists," and the four rules that stop it from wrecking your day.

More principles and anonymized case studies land in v0.2 if this is useful to people. Tell me by starring or opening an issue.

## Getting started

The [quickstart](#quickstart-60-seconds) above is the fast path. This section unrolls the same adoption by hand, for people who want to see every moving part first. Five steps, none of them long.

### 1. Get the files

```bash
# clone it
git clone https://github.com/chocomyong/harness-kit.git

# or grab it without git history
curl -L https://github.com/chocomyong/harness-kit/archive/refs/heads/main.tar.gz | tar xz
```

### 2. Copy the templates you want into your repo

Start small. The one file that matters most is the canon; everything else is optional and additive. (This is exactly what `install.sh` automates.)

```bash
# the minimum: one canonical rules file at your repo root
cp harness-kit/templates/AGENTS.md ./AGENTS.md

# recommended next
cp harness-kit/templates/WORK_PROTOCOL.md ./WORK_PROTOCOL.md
cp harness-kit/templates/PATTERNS.md      ./PATTERNS.md
cp harness-kit/templates/pattern-card.md  ./docs/pattern-card.md   # optional format reference
```

`AGENTS.md` must sit at the repo root - that is where engines look for it. If four rules files at root is more clutter than you want, `WORK_PROTOCOL.md` and `PATTERNS.md` can live under `docs/` instead; just update the paths your `AGENTS.md` points at (sections 4 and 6).

### 3. Fill in the blanks - or have your agent do it

The fast path: paste the bootstrap prompt from the quickstart and let the agent fill `AGENTS.md` from measured facts, then review its diff. Filling by hand instead? Open `AGENTS.md`, replace every `<PLACEHOLDER>`, delete sections you do not need. Where to spend your fifteen minutes, in order:

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
| **Gemini CLI** | Add a one-line `GEMINI.md`: "Read AGENTS.md and follow it." (Or point `contextFileName` at `AGENTS.md` in `.gemini/settings.json`.) |
| **Windsurf** | Add a one-line `.windsurfrules`: "Follow the rules in AGENTS.md." |
| **Anything else** | Put it in the system prompt or your first message: "Read AGENTS.md and follow it." |

### 5. Confirm it stuck

Ask the agent: *"Summarize the rules in AGENTS.md in five bullets and tell me the top invariant."* If it answers from your file, it is loaded. If it makes something up, it never read it - go back to step 4 and fix the wiring.

## Who this is for

You use a coding agent as a **daily driver** on a **long-lived** codebase - one with history, scars, and load-bearing weirdness that "looks wrong but is right" - and you are tired of re-teaching the same lessons every session. Extra credit if you run **more than one** engine and want them under the same rules.

If you are writing throwaway scripts, you do not need this. Come back when the code has to survive.

## Where this came from

These rules were not invented at a whiteboard. They were extracted while building and operating **IME (Integrated Monitoring Environment)** - a self-hosted Flask monitoring dashboard that grew to roughly **41,000 lines** of Python, JavaScript, CSS, and templates across **19 route modules** (past 60,000 counting the crawler engines and shared libraries it runs in-process) - and the cluster of sibling tools that grew up beside it in the same monorepo: a ranking web board, several notification-watcher daemons, a trading-research harness, a daily-chart crawler. Roughly **ten runnable apps and daemons** totaling about **190,000 lines of code**, one developer, **~4,500 commits since January 2026**, all deployed to a self-hosted box that had to stay up while the code changed under it.

The `pattern-card.md` format is not hypothetical either: that codebase carries **39 numbered failure patterns**, each one a bug that cost real time and earned its card. The version markers in the worked example (the `v6.7.x` in the 502 case study) are real entries from that log, not invented for illustration.

That is the whole pitch: these rules have receipts. The names, servers, and business details are stripped for privacy, but the scar tissue is genuine - and every number above is measured, not rounded up.

## FAQ

**Isn't this just common sense?** Mostly, yes - written down, with the receipts for what it cost when it was skipped. The repo this came from carries 39 numbered records of common sense failing under real deadline pressure, each with the version where it failed. Rules earn a place here by breaking, not by sounding wise. If your team already applies all of this unwritten, you genuinely do not need the kit.

**The source repo is private. Where are the receipts?** The origin monorepo runs personal infrastructure, so it stays private and everything here is stripped of names and addresses. What could be published, was: the 502 case study in [`pattern-card.md`](templates/pattern-card.md) is a real card with its real debug path including the dead ends, and every number in "Where this came from" is measured from the tracked tree, not estimated. Beyond that, judge the rules by whether they hold up in your repo - which is the only receipt that matters anyway.

**Was this written with AI?** Yes - by coding agents operated under exactly the discipline it describes, steered and reviewed by the human who accumulated the scars. It would be strange if a kit about operating coding agents were produced any other way. The commit trailers say which engine co-authored what; treat the repo itself as the demo.

**I already have a `CLAUDE.md` and house rules. Do I start over?** No - **absorb, do not transplant.** The kit's ideas outrank its files: a named top invariant, absence-judgment as an explicit rule, and an index-first incident registry are worth folding into the docs you already run, in your language and your format. What you should *not* do is install a second rules system beside the one you have - the same rule stated in two places drifts, which is literally card 01 in [this repo's own registry](PATTERNS.md). [`PROMPTS.md`](PROMPTS.md) has a paste-ready absorb prompt for exactly this case.

**Doesn't Claude Code's `/init` - or its memory feature - already do this?** They solve a different layer. `/init` and its cousins write down what your repo *is* (layout, build commands); this kit writes down how not to *wreck* it (the invariant, the destructive-op gates, the absence discipline, the incident cards) - opinionated content no engine generates for you. And engine memory is per-machine, per-engine, and invisible to review; the canon and `PATTERNS.md` live in the repo, travel with every clone and teammate, and read the same to whatever agent you adopt next. The more engines ship their own proprietary rules files, the more an engine-neutral canon is the thing keeping them from drifting apart.

**Why not just one big `CLAUDE.md`?** Because the day you add a second engine - Codex, Cursor, whatever ships next quarter - your rules either fork into two drifting copies or the second agent runs without rules. The canon is engine-neutral on purpose, and `CLAUDE.md` here is a thin importing appendix. The reasoning is written out in [`templates/CLAUDE.md`](templates/CLAUDE.md).

## Prior art and credit

This kit stands on other people's ideas:

- The **fresh-context iteration loop** in `ralph-goal.md` is Geoffrey Huntley's "Ralph" pattern. Read the original: https://ghuntley.com/loop/
- The **`AGENTS.md` convention** for an engine-neutral agent instruction file is a community standard: https://agents.md
- The pre-spec "grill me" thinking that informs `WORK_PROTOCOL.md` owes a debt to Matt Pocock's work on planning with agents.

harness-kit's contribution is not inventing these. It is **wiring them into one coherent operating discipline** and writing down the failure modes that made each rule necessary.

## License

MIT. Take it, fork it, adapt it. If it saves you a bad afternoon, a star is thanks enough.
