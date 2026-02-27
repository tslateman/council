# The Five Levels of AI Coding

Companion to [The Specification Bottleneck](specification-bottleneck-pitch.md).
That document frames the problem. This one maps the path.

Dan Shapiro's five levels[^1] describe AI integration from autocomplete to full
autonomy. Most teams plateau at Level 2. Specification quality keeps them there.

## The Levels

| Level | Developer Role       | AI Scope                                                   |
| ----- | -------------------- | ---------------------------------------------------------- |
| 0     | Spicy Autocomplete   | Suggests the next line                                     |
| 1     | Coding Intern        | Writes functions, refactors modules                        |
| 2     | Junior Developer     | Multi-file changes; humans review all code                 |
| 3     | Developer as Manager | Humans direct AI, review feature-level output              |
| 4     | Developer as PM      | Humans write specs, evaluate outcomes without reading code |
| 5     | Dark Factory         | Specs in, working software out                             |

Most developers sit at Level 2.[^1] Most top out at Level 3.

## The Level 3 Ceiling

The barrier from 3 to 4 is psychological, not technical.[^1] Developers resist
stopping code review. The skill shifts from reading code to writing
specifications precise enough that review becomes verification against intent.

Level 4 requires trust in the system and strong spec-writing. Level 5 requires
both plus organizational redesign.

## What Level 5 Looks Like

StrongDM: three people, production software, no human-written or human-reviewed
code.[^1] Two choices make it work:

1. **Scenarios complement tests.** Scenarios live outside the codebase as
   holdout sets, preventing AI from optimizing for test passage over correct
   behavior.
2. **Digital twin environment.** Behavioral clones of external services allow
   full integration testing without live dependencies.

The pattern: separate specification from implementation so completely that AI
cannot game the verification.

## Why the Middle Levels Feel Worse

Experienced developers measure 19% slower with AI tools.[^2] Evaluating
suggestions, correcting errors, and debugging AI-introduced problems outweigh
generation speed. This is the J-curve from
[The Specification Bottleneck](specification-bottleneck-pitch.md): productivity
dips before it improves.

Organizations misread the dip as failure. It is evidence the team sits in the
trough between levels.

## What Changes Organizationally

Traditional structures built for human limitations become friction at higher
levels.[^1]

- **Roles** move from conductor to orchestrator.[^3] Specifying intent replaces
  managing people.
- **Hiring** shifts toward generalists who think across domains. AI handles
  implementation; humans handle understanding.
- **The junior pipeline collapses.** Entry-level coding automates first. The
  path into engineering changes.

## The Brownfield Problem

Most companies start with legacy systems full of implicit knowledge no one
documented.[^1] The hard work is reverse-engineering that knowledge into
explicit specifications before AI can operate on it.

Greenfield reaches higher levels faster. Brownfield requires specification
archaeology first.

## Demand Never Saturates

Cheaper production opens new markets, not fewer jobs.[^1] Value accrues to those
who understand customers deeply enough to articulate what needs building.

Specification quality is the durable skill at every level.

## Implications for Us

| Question                          | Diagnostic                                           |
| --------------------------------- | ---------------------------------------------------- |
| What level are we at today?       | Where does human review happen in our workflow?      |
| What holds us at this level?      | Skill gap, trust gap, or organizational friction?    |
| What does Level N+1 require?      | Better specs, better verification, or both?          |
| Where is our brownfield exposure? | Which systems carry undocumented implicit knowledge? |

Counterpoint: [The Subtraction Test](the-subtraction-test.md).

[^1]:
    [The 5 Levels of AI Coding](https://www.youtube.com/watch?v=bDcgHzCBgmQ), AI
    News & Strategy Daily, Nate B Jones.

[^2]:
    [METR, arXiv:2507.09089](https://arxiv.org/abs/2507.09089). Peer-reviewed
    RCT. 40-percentage-point perception gap: developers felt faster while
    measured output fell.

[^3]:
    [Conductors to Orchestrators](https://www.oreilly.com/radar/conductors-to-orchestrators-the-future-of-agentic-coding/),
    O'Reilly Radar.
