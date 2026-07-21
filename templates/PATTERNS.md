# PATTERNS.md - incident / pattern registry

> When a bug teaches you something that is not obvious from the code alone, it gets a numbered card here. Before planning any change, scan this file for cards that touch your area and name them in the plan ("relevant: PATTERN-03"). This is what stops an agent from "improving" a guard away and re-opening a bug you already closed.
>
> Each card is 4 blocks - **symptom / debug path / root cause / prevention rule** - plus the version or date learned. "Be careful" is not a prevention rule; a checkable instruction is. Format rationale and a real worked example: harness-kit's [`pattern-card.md`](https://github.com/chocomyong/harness-kit/blob/main/templates/pattern-card.md).

---

### PATTERN-01: <one-line name of the failure>

- **Symptom:** <what you actually see - the error, the wrong output, the crash - not the cause>
- **Debug path:** <what you looked at, in what order, including the dead ends>
- **Root cause:** <one or two sentences. If you cannot state it this tightly, you have not found it yet>
- **Prevention rule:** <the concrete, checkable rule that stops recurrence> (learned <version/date>)
