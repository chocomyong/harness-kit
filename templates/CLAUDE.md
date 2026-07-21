# CLAUDE.md - Claude Code appendix

> **The canon is [`AGENTS.md`](AGENTS.md)** and it is imported below. This file holds only the machinery that exists in Claude Code and nowhere else: skills, subagents, hooks. Rules that any engine should follow do NOT go here - they go in the canon, or other engines will drift out of sync.

@AGENTS.md

---

## Why the split

If you put your real rules in `CLAUDE.md`, then the day you add Codex (or any other agent) you have two choices: duplicate everything, or let the second agent run without rules. Both are bad. Instead:

- **`AGENTS.md`** = engine-neutral canon. Every agent reads it. One source of truth.
- **`CLAUDE.md`** = Claude-Code-only appendix. It `@import`s the canon, then adds the Claude-specific machinery below.

A non-Claude engine reads `AGENTS.md` directly and is fully equipped. A Claude Code session reads this file, which pulls in the canon plus the extras. Nothing is written twice.

**This file works as-is.** The one load-bearing line is the `@AGENTS.md` import above. If you have no skills, subagents, or hooks yet, the placeholder tables below are inert - fill them as the machinery appears, or delete them.

---

## Skills (`.claude/skills/`)

> Skills are a **trigger layer**, not the rulebook. The rule body lives in a canonical doc; the skill just fires it at the right moment. If you edit the skill but not the canonical source, other engines drift. Always edit the source first.

| Skill | Fires when | Canonical source |
|---|---|---|
| `<skill-name>` | `<trigger, e.g. any code commit>` | `<the doc that actually defines the rule>` |

## Subagents (`.claude/agents/`)

> Delegate area-limited work to a specialized subagent. Cross-cutting work stays with the parent. Keep each agent's scope tight so it refuses out-of-area edits.

| Agent | Scope | Trigger keywords |
|---|---|---|
| `<domain>-developer` | `<path glob>` | `<keywords>` |
| `code-reviewer` | pre-commit review, any area | "review before commit" |

## Hooks (`.claude/settings.json`)

| Hook | Script | Purpose |
|---|---|---|
| SessionStart | `<script>` | `<e.g. confirm local branch matches origin>` |
| PreToolUse (Edit/Write) | `<script>` | `<e.g. early warning on known crash patterns>` |

---

## Author-is-not-verifier

A single agent that checks its own work stays inside the same blind spot that produced the work. After a batch of changes - and always after an autonomous loop - fire an **independent** review agent (`code-reviewer`) over the commit range. It reasons from a fresh frame and catches the edge case the author's frame hid. Treat a blocking finding as a required fix before push, not a suggestion.
