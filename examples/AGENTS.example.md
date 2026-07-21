# AGENTS.md - canonical agent instructions (filled example)

> **What this is:** harness-kit's `templates/AGENTS.md` filled in end-to-end for a fictional-but-realistic project, so you can see what a finished canon looks like. The project - "beacon", a self-hosted club membership and dues tracker - is invented. The *shape* is real: this is roughly what the bootstrap prompt produces in about ten minutes of agent survey plus one human confirmation of the invariant.
>
> Notice what filling in does: the guidance blockquotes are gone, every rule now names a concrete file, and the invariant reads like a threat because it is one.

---

## Why this file exists (do not delete this note)

An agent's context resets. Yours does not. Every rule below is here because breaking it cost someone real time. When you are tempted to "clean up" a rule you do not understand, assume it is load-bearing and ask first. The reason a thing looks the way it looks is written down in this repo, not guessed at.

---

## 0. Top invariant - the one thing that must never break

**The production members database (`data/beacon.db` on the server) is never overwritten from a development copy.** The live app writes it; dues payments recorded there exist nowhere else. Sync runs one direction only: **server -> repo snapshot**, nightly. Before any work that touches `data/`, `deploy/`, or anything that runs `rsync`/`scp`, state the sync direction in your plan and confirm the target. A reversed sync silently destroys every payment recorded since the last snapshot.

This is the first thing every agent reads and the last thing it double-checks before committing.

---

## 1. Repo map - what lives where

| Area | Path / entry point | Status | Notes |
|---|---|---|---|
| web app ("the portal") | `portal/app.py` | live | Flask + htmx; routes live in `portal/routes/`, not app.py |
| dues worker | `worker/dues.py` | live | cron daemon; sends payment-reminder emails |
| member importer v2 | `tools/import_members.py` | live | the only supported import path |
| importer v1 | `legacy/import_v1.py` | **retired** | superseded 2025-11; kept for history - do not modify, do not "fix" |
| deploy scripts | `deploy/` | live | the server pulls; dev machines never push data (section 0) |

**Naming:** when the team says "the portal" they mean `portal/app.py` and its routes - not the worker. "The importer" always means v2; v1 is retired.

**Retired means checked, not assumed:** before marking anything else retired, check whether the logic *moved* rather than died. Entry points die; core functions migrate to new modules and live on. Calling live code dead is the more expensive mistake (see WORK_PROTOCOL section 7).

---

## 2. Work rhythm - leave the repo better than you found it

Every substantial task runs this loop:

1. **Structure** - read the relevant code and its docs by actually looking, not from memory.
2. **Context** - `git log`, `CHANGELOG.md`, and `PATTERNS.md` tell you *why* it is shaped this way.
3. **Plan** - state the change, blast radius (shared modules, data, deploy), and risk in one paragraph before editing.
4. **Execute** - minimal, surgical change. Version bump and changelog entry ride in the same commit.
5. **Verify** - run it. "Should work" is not verification. Quote the command and its output.
6. **Immortalize** - the adjacent bug, tacit rule, or weakness you found along the way goes into `PATTERNS.md` so the next loop is smarter.

**Done means both:** (a) the request is handled, and (b) the repo is measurably better than before. Skip this for trivial one-line fixes and questions, but if you see a defect while passing through, record it.

---

## 3. Commit and change contract

- **Commit format:** `[<area> vX.Y.Z] <category>: <summary>` where area is `portal`, `worker`, or `importer`. Version constants: `portal/version.py`, `worker/version.py`, `tools/version.py`. Never omit the area - three components share one `git log`.
- **File-companion rule:** every behavior change updates `CHANGELOG.md` in the same commit. Every schema change updates `docs/SCHEMA.md` in the same commit. A runtime `KeyError` is almost always one side of a contract changing while the other side did not know.
- **Engine trailer:** agent-authored commits end with `Co-Authored-By: <engine> <email>`.
- **Destructive ops need a human:** force-push, hard reset, branch deletion, file deletion, schema drops. The agent proposes; a human decides.
- **Destructive commands name their target:** importer runs always pass `--season` explicitly - the argparse default points at the **live** season. Same for any command that overwrites or deletes: dataset, table, and path spelled out, never defaulted.
- **Parallel-session guard:** more than one agent may share this working tree. Right before committing, read the last ~3 commits - if another session already shipped your topic, verify convergence instead of duplicating. Right after committing, read `git show --stat HEAD` - missing files while the tree is clean means another session's commit absorbed your edits.
- **Before committing:** read `git diff --staged` in full. If `data/beacon.db` is staged, unstage it immediately - a stale dev copy reaching main is the section-0 disaster in slow motion.

---

## 4. Incident / pattern registry - the answer to "why is it like this?"

Location of the registry: **`./PATTERNS.md`** (currently PATTERN-01 through PATTERN-06).

Each entry is a 4-block card: **symptom / debug path / root cause / prevention rule**, plus the version or date it was learned. Before planning any change, scan the registry for cards that touch your area and name them in the plan - e.g. any work near the worker must cite PATTERN-03 (*reminder emails sent twice when the worker restarts mid-batch*).

---

## 5. Reporting and style

- **Conclusion first.** What worked, what did not, then the reasoning. Report failures with their actual output, not a summary of it.
- **Evidence, not vibes.** "Verified: `<command>` -> `<observed output>`." If you could not run it, write "unverified" - do not dress a guess as a result.
- House style: English for code, commits, and docs. Plain ASCII in commit messages - no emoji. Member names and emails never appear in commits, logs, or test fixtures; use the anonymized seed data in `tests/fixtures/`.

---

## 6. Pointers

The *how you think* layer lives in [`WORK_PROTOCOL.md`](../templates/WORK_PROTOCOL.md): this file says *what* the rules are; that one says *how to reason while applying them*. Both apply at once. Engine-specific tooling lives in the engine appendix, e.g. `CLAUDE.md`.
