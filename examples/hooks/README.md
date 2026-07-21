# Enforcement examples - gates, not prose

The kit's thesis is that prose rules get forgotten, so the load-bearing ones should live where they are **enforced**. These are two working examples of that. Both are optional, both are engine- or tool-specific (which is why they live here and not in the neutral canon), and both are meant to be edited, not worshiped.

| File | Enforces | Layer |
|---|---|---|
| [`pre-commit`](pre-commit) | "the section-0 invariant file never gets committed by accident" | git (any engine, any editor) |
| [`claude-settings.json`](claude-settings.json) + [`check_destructive.sh`](check_destructive.sh) | "destructive git needs a human yes" (AGENTS.md section 3) | Claude Code PreToolUse hook |

## Install the git pre-commit

```bash
cp examples/hooks/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
# then edit the PROTECTED list at the top to your section-0 file(s)
```

To share the hook with every clone, commit it to a tracked directory instead and run `git config core.hooksPath <that-dir>` once per clone.

## Install the Claude Code hook

Merge the `hooks` block from `claude-settings.json` into your repo's `.claude/settings.json`, and copy `check_destructive.sh` to `.claude/hooks/` (path referenced in the snippet). Claude Code then consults the script before every Bash call; exit code 2 blocks the call with the message shown to the agent.

Other engines have equivalent seams (Codex and Cursor both support project-level command policies); the git hook above covers every engine at once, which is why it comes first.

**Honest ceiling:** command-string matching is defense-in-depth, not a hard gate - aliases, `eval`, or creative spacing can slip past it. The git pre-commit is the reliable, engine-wide net; treat the PreToolUse matcher as a best-effort backstop, never a guarantee.
