# Incident / pattern card

> A pattern card moves the reason a fix exists **out of your head and into the repo**, in a format an agent will actually read and respect. This is what stops an agent from "cleaning up" a guard it does not understand and re-opening a bug you already closed.
>
> Keep cards in one registry file (or one per subsystem) near the code they protect. Number them so plans can reference them ("relevant: PATTERN-14"). Add a new card whenever a bug teaches you something that is not obvious from the code alone.

## The 4-block format

Copy this block for each new pattern.

```markdown
### PATTERN-<NN>: <one-line name of the failure>

- **Symptom:** how it shows up. What you actually see - the error, the wrong output, the crash - not the cause. Multiple symptoms with one cause? List them all here; that they co-occur is a clue.
- **Debug path:** what you looked at and in what order before the cause revealed itself. This is the part people omit and the part that saves the next person the most time. Record the dead ends too.
- **Root cause:** why it actually happens. One or two sentences. If you cannot state it this tightly, you have not found it yet (see WORK_PROTOCOL section 3).
- **Prevention rule:** the concrete, checkable thing that stops recurrence. "Be careful" is not a rule. "Always pass `**kwargs` to the worker callback" is a rule. Include the version/date learned.
```

## Worked example (anonymized)

This is a real, sanitized case from the repo this kit came from. It shows why the format earns its keep: three symptoms, one root cause, and a fix that only makes sense once the cause is written down.

```markdown
### PATTERN-29: single worker + short timeout + heavy job -> site-wide 502 cascade

- **Symptom:** 502s on everything (even static assets), websocket sessions dropping,
  first-paint latency of 30-75s, login timing out, empty feeds, and the scheduler
  refusing new jobs - all at once. Looked like five separate bugs.
- **Debug path:** chased the websocket errors first (dead end), then the static-asset
  502s (dead end), then capped response sizes and disabled jobs (made it worse). The
  turn came from NOT trusting the server's own "worker killed, perhaps out of memory"
  log line and checking the kernel OOM log directly - which was empty. So it was not
  memory. It was the request timeout.
- **Root cause:** one worker with a 30s request timeout, running jobs that take longer
  than 30s. The master kills the worker on timeout; with a single worker, every request
  is a 502 until it respawns; the heavy job runs again; repeat. And the thread count was
  below the number of render-blocking assets, so static files queued behind it.
- **Prevention rule:** timeout must exceed the slowest routine job; thread count must
  meet or exceed the render-blocking asset count. And: a "killed, maybe OOM" log is a
  heuristic, not a diagnosis - confirm OOM against the kernel log before believing it.
  (learned v-<x>, the fix took 4 versions after 18 versions of chasing symptoms)
```

The lesson the card encodes is not just "raise the timeout." It is **"multiple symptoms can share one cause, and the server's own explanation for a crash can be wrong."** That is the kind of hard-won knowledge that vanishes the moment the person who debugged it moves on - unless it is written here.
