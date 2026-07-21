# AGENTS.md - canonical agent instructions

> **This is the canon.** It is the single source of truth for how any coding agent works in this repo (Claude Code, Codex, or whatever comes next). Engine-specific machinery lives in a thin appendix (see `CLAUDE.md`); rules that apply to every engine live here, so nothing drifts between tools.
>
> How to use this template: replace every `<PLACEHOLDER>`, delete sections you do not need, keep the structure. Fastest path: paste the bootstrap prompt from the harness-kit README and let your agent fill the blanks from measured facts. The value is having a canon at all and making every agent read it.

---

## Why this file exists (do not delete this note)

An agent's context resets. Yours does not. Every rule below is here because breaking it cost someone real time. When you are tempted to "clean up" a rule you do not understand, assume it is load-bearing and ask first. The reason a thing looks the way it looks is written down in this repo, not guessed at.

---

## Agent bootstrap - if this file still contains placeholders

If you are a coding agent reading this and `<PLACEHOLDER>` marks remain below, **filling them is your first task.** Survey the repo - the actual file tree, `git log`, existing docs - and propose measured values for every blank:

- **Measured, not guessed.** Every value you propose must come from something you read in *this* repo, not from what repos like this usually look like.
- **The top invariant is confirmed by a human.** Propose candidates when you see them (a production datastore, a one-way data sync, a paid external API) - but never invent one, and never delete section 0 without asking.
- **Show the diff before saving.** You fill; the human confirms.

Until the blanks are filled, operate under the safe defaults noted per section.

When every blank is filled and confirmed, **delete this section and the guidance blockquotes** - a finished canon reads like a rulebook (see harness-kit's `examples/AGENTS.example.md`), not like a form.

---

## 0. Top invariant - the one thing that must never break

> State the single highest-stakes fact about this repo. The thing where a mistake is unrecoverable. Examples: a production database that must never be overwritten, a payment path that must never run in a test, a customer dataset that only ever syncs one direction.

**`<INVARIANT>`.** Before any work that could touch it, `<the guard you must confirm first>`.

**Safe default while unfilled:** assume an invariant you cannot see exists. Treat every destructive or irreversible operation - file deletion, schema drop, force-push, bulk overwrite, sending data off the machine - as potentially touching it, and stop to ask a human first.

If your repo has no such thing, delete this section. If it does, this is the first thing every agent reads and the last thing it double-checks before committing.

---

## 1. Repo map - what lives where

> Agents waste tokens and hallucinate when they do not know the layout. Give them the map. Mark what is live vs. retired explicitly - an agent that thinks live code is dead will avoid touching it, which is as bad as deleting it.

| Area | Path / entry point | Status | Notes |
|---|---|---|---|
| `<app or module>` | `<path>` | live | `<one line>` |
| `<retired thing>` | `<path>` | **retired** | do not modify; kept for history only |

**Naming:** when the team says "`<informal name>`" they mean `<exact path>`. Write the synonyms down so the agent scopes work correctly.

**Retired means checked, not assumed:** before marking anything retired, check whether the logic *moved* rather than died. Entry points die; core functions migrate to new modules and live on. Calling live code dead is the more expensive mistake - the next agent will route around working code (see WORK_PROTOCOL section 7).

---

## 2. Work rhythm - leave the repo better than you found it

> This is the compounding loop. "Handled the request" is not done. "Handled the request AND left one durable improvement" is done. Each loop's output becomes the next loop's input, so the repo teaches the next agent.

Every substantial task runs this loop:

1. **Structure** - read the relevant code and its docs by actually looking, not from memory.
2. **Context** - `git log`, changelog, and the incident registry (section 4) tell you *why* it is shaped this way.
3. **Plan** - state the change, blast radius (shared modules, data, deploy), and risk in one paragraph before editing.
4. **Execute** - minimal, surgical change. Version bump and changelog entry ride in the same commit.
5. **Verify** - run it. "Should work" is not verification. Quote the command and its output.
6. **Immortalize** - the adjacent bug, tacit rule, or weakness you found along the way goes into the registry (section 4) so the next loop is smarter.

**Done means both:** (a) the request is handled, and (b) the repo is measurably better than before (one hardening or one pattern recorded). Skip this for trivial one-line fixes and questions, but if you see a defect while passing through, record it.

---

## 3. Commit and change contract

> Format is enforced so `git log` stays a usable index across multiple agents and humans.

- **Commit format:** `<your format, e.g. [vX.Y.Z] category: short summary>`. Never omit `<the required parts>`.
- **File-companion rule:** every behavior change updates `<CHANGELOG file>` in the same commit. Every schema change updates `<the interface registry>` in the same commit. A runtime `KeyError` is almost always one side of a contract changing while the other side did not know.
- **Engine trailer:** agent-authored commits end with a trailer naming the engine (`Co-Authored-By: <engine> <email>`), so a later investigator can tell which tool wrote what.
- **Destructive ops need a human:** force-push, hard reset, branch deletion, file deletion, schema drops. The agent proposes; a human decides.
- **Destructive commands name their target:** any command that overwrites or deletes data carries its target arguments explicitly (dataset, region, table, path) - never lean on a tool's default value. A single omitted target flag once replaced a live dataset's rows with another's because the default pointed somewhere real.
- **Parallel-session guard:** multiple agents may share one working tree. Right before committing, read the last ~3 commits - if another session already shipped your topic, verify convergence instead of duplicating. Right after committing, read `git show --stat HEAD` - if intended files are missing while the tree is clean, another session's commit absorbed your edits; trace them via reflog instead of re-editing blind.
- **Before committing:** read `git diff --staged` in full. Unintended files are how the invariant in section 0 gets violated by accident.

---

## 4. Incident / pattern registry - the answer to "why is it like this?"

> This is the single highest-leverage habit in the kit. When a bug teaches you something, you record it as a card so the agent cannot "improve" the fix away. See `pattern-card.md` for the format. Keep the cards near the code they protect.

Location of the registry: `./PATTERNS.md` (seeded there by install.sh - change this line if you keep it elsewhere).

Each entry is a 4-block card: **symptom / debug path / root cause / prevention rule**, plus the version or date it was learned. Before planning any change, check the registry's **index** for cards that touch your area, open those cards, and name them in your plan. (The index-first read is what keeps this scaling as cards accumulate.)

---

## 5. Reporting and style

- **Conclusion first.** What worked, what did not, then the reasoning. Report failures with their actual output, not a summary of it.
- **Evidence, not vibes.** "Verified: `<command>` -> `<observed output>`." If you could not run it, write "unverified" - do not dress a guess as a result.
- `<your house style: language, emoji policy, punctuation preferences, forbidden phrases>`.

---

## 6. Pointers

The *how you think* layer lives in [`WORK_PROTOCOL.md`](WORK_PROTOCOL.md): this file says *what* the rules are; that one says *how to reason while applying them*. Both apply at once. Engine-specific tooling (skills, subagents, hooks) lives in the engine appendix, e.g. `CLAUDE.md`.
