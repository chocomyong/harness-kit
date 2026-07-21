# Absence-judgment: the failure mode nobody warns you about

There is a specific way coding agents fail that does not look like failure. The agent is not confused. It is not hallucinating a fake API. It is calm, fluent, and completely sure of itself when it tells you:

> "There is no backup for that database."
> "That function is dead code, safe to remove."
> "There is no rate limiting anywhere in this module."
> "This config option does not exist."

And it is wrong. The backup was implemented last week. The function is called every sixty seconds from a file the agent did not open. The rate limiting is right there under a name the agent did not grep for.

This is **absence-judgment failure**, and it is worth its own essay because it is common, it is quiet, and it is asymmetrically dangerous.

## The two ways to be wrong are not equally bad

When you judge whether something exists, you can be wrong in two directions, and people treat them as symmetric. They are not.

**Call a dead thing alive** (a false negative on "is it gone?"). Someone wastes effort maintaining or working around code that no longer matters. Annoying. Cheap to reverse. You find out fast, because the thing you are protecting never actually does anything.

**Call a live thing dead** (a false positive). This is the expensive one. Write "do not touch this, it is retired" in a doc, and you have functionally deleted it - not from the codebase, but from the mind of every agent and human who reads that doc afterward. They will route around live code. They will rebuild something that already exists. And in the worst case, they will design a recovery plan around a safety net they have been told is not there.

The reason the second direction is worse: **a wrong "it is gone" hides. A wrong "it is here" gets caught.** If you falsely believe something exists, you go looking for it, fail to find it, and the error surfaces. If you falsely believe something is absent, nothing ever contradicts you. You have removed the evidence from your own search.

## The deeper asymmetry: absence costs more to prove

Here is the principle under the principle:

> **Presence is proven by one instance. Absence requires an exhaustive check.**

To justify "X exists," you need exactly one example. One `file:line`. Done.

To justify "X does not exist," you need to have looked everywhere X could be and found nothing. That is a fundamentally more expensive claim. And almost nobody pays for it. What actually happens is:

- You grep one spelling of the name and it is not there, so you conclude it is nowhere. (It was spelled differently.)
- You read a file's title, see "Legacy GUI stuff," and write off the whole file. (Its second half documents live server modules.)
- You check one variable in a script and decide the script does not do the thing. (The answer was three lines down.)
- You look at the health dashboard, see only one backup listed, and conclude the others do not exist. (The dashboard just does not render them.)

Every one of these is the same mistake: **you cut the evidence at one point and treated a single observation as a complete search.** That is not a judgment. It is a guess wearing the costume of a judgment.

## "Not on my screen" is not "does not exist"

The dashboard example deserves its own line, because it is the trap that catches careful people.

An agent, or a person, checks the one surface that is supposed to show a thing. The thing is not on that surface. Conclusion: the thing is absent. But the surface was incomplete. The backup existed; the health page simply did not display it. The observation gap became a false absence.

So: **"I cannot see it" is a fact about your instruments, not about the world.** When a tool does not show something, you have learned that the tool does not show it. You have not learned that it is not there. And the gap itself - the fact that a real thing has no visible confirmation - is usually a defect worth fixing, because the next person will fall into exactly the same hole.

## Why this is dangerous, in order of increasing damage

1. **Wasted work.** You rebuild something that already exists. Recoverable.
2. **Bad design.** You architect around a capability you think is missing - adding a fallback for a case already handled, or worse, treating an existing safety net as absent.
3. **The incident case.** Something breaks. You need the backup, the recovered copy, the thing you were told does not exist. You do not look for it, because you "know" it is not there. This is the one that turns a recoverable outage into a real loss.

The through-line: a false absence is most harmful exactly when you need the thing most, because that is when you stop looking.

## The rules

These are cheap to follow and they close the gap.

1. **Do not judge by filename or title. Read to the end of the section.** A file titled after a dead thing can document five live ones in its second half. The header is a label, not a summary.

2. **Ask "did the logic move?" before "is it gone?"** An entry point can die while its core function lives on, called from somewhere else. Retired launcher, live library. Check for the relocation before you write the obituary.

3. **Count, do not glance.** Mechanically tally the live references against the dead ones. If live references are non-trivial, you may not declare the whole thing dead. Split it: label section by section.

4. **Write "what is alive AND what is dead," never just "what is dead."** A banner that only lists the dead parts, if it is wrong, is unrecoverable - nobody re-checks it. A banner that also names the live parts at least points the next reader at solid ground.

5. **Before you write "X does not exist," go find X.** Absence is the expensive claim; pay for it. If you looked in one place and stopped, you have not earned the conclusion. One variable, one filename, one grep line is not an exhaustive search.

6. **Suspect your instruments.** If your evidence for absence is "the dashboard does not show it" or "it is not in the file I opened," that is an observation gap, not an absence. Widen the search, or say "I could not confirm it either way" - which is honest - instead of "it is not there" - which is a guess.

## The one-line version

If you remember nothing else: **"X does not exist" is a far more expensive claim than "X exists," so demand far more evidence before you let an agent - or yourself - say it.**

---

*This is one card from [harness-kit](https://github.com/chocomyong/harness-kit), a small set of operating rules for keeping coding agents honest on codebases that have to survive. It was distilled from a real incident log: the day a repo's own docs and one agent, in a single afternoon, declared seven live things dead or missing - and every one of them was still there.*
