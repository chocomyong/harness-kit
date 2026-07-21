# PATTERNS.md - harness-kit's own incident registry

> This is the kit eating its own dog food: the format from [`templates/PATTERNS.md`](templates/PATTERNS.md) applied to the kit itself. The cards below are real defects found in this repo - mostly by external review - and the rules that keep them from recurring. The file you copy into *your* repo is the template, not this one.

## Index - area to cards

| Area | Cards |
|---|---|
| rule files (`templates/`, `MINIMAL.md`, `PROMPTS.md`, `examples/`) | 01 |

---

### PATTERN-01: a rule stated in more than one file drifts on edit

- **Symptom:** `templates/AGENTS.md` section 4 said "check the registry's index" while `templates/WORK_PROTOCOL.md` section 0 still said "scan the registry" - the scaling fix landed in one of the rule's several statements. A second external review caught it; the first review had already flagged the same class (MINIMAL.md restating the templates with no declared source).
- **Debug path:** the fix commit (89a230a) touched AGENTS.md and the PATTERNS seed. Nobody grepped for other statements of the registry-read rule before committing. The reviewer did: WORK_PROTOCOL.md, PROMPTS.md, and examples/AGENTS.example.md all still carried the old wording.
- **Root cause:** the same rule was stated in prose in four files, and an edit landed in one. Duplication is sometimes deliberate here (MINIMAL.md is a declared derivation) - but deliberate duplication makes re-derivation part of every edit, and that step was not written down anywhere.
- **Prevention rule:** before committing a change to any rule's wording, grep the repo for the rule's key phrase and either update every statement in the same commit or add the missing cross-reference. A rule stated in two files is edited in both, or in neither. (learned 2026-07, external review round 2)
