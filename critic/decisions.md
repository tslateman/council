# Decision-Making Cheat Sheet

Decisions compound. The meta-skill is knowing which ones matter.

## Tooling

Coalesce operationalizes the frameworks below for prototype convergence --
structured trade-off analysis, conflict detection, consensus testing, and
decision recording across competing solutions. The Critic owns the judgment
criteria Coalesce applies.

## The Decision Spectrum

| Type             | Reversibility | Time to Decide | Examples                                     |
| ---------------- | ------------- | -------------- | -------------------------------------------- |
| **One-way door** | Hard/costly   | Take your time | Architecture, hiring, public commitments     |
| **Two-way door** | Easy/cheap    | Decide fast    | API naming, tool choice, process tweaks      |
| **Sliding door** | Window closes | Decide or lose | Market timing, role opportunities, headcount |

**Bezos framing**: Most decisions are two-way doors. Treat them that way.
Reserve slow deliberation for the few that aren't.

## Decision Quality vs Outcome Quality

```text
                    Good Outcome    Bad Outcome
Good Decision       Deserved win    Bad luck
Bad Decision        Dumb luck       Deserved loss
```

**The trap**: Judging decisions by outcomes. A good process can yield bad
results; a bad process can get lucky.

**What to optimize**: Decision quality (process), not outcome (results). Over
time, good process wins.

## When to Decide

### Decide Now

- Two-way door (cheap to reverse)
- Cost of delay exceeds cost of being wrong
- Your team waits on you
- You have enough information (not all, enough)
- Your gut has a clear signal

### Wait for More Information

- One-way door with high stakes
- Key data arriving soon
- You're emotionally activated
- The "obvious" answer feels too easy
- You haven't heard from stakeholders

### Never Decide

- Someone closer to the problem should decide
- It's not actually your decision to make
- The decision will make itself with time
- Someone wants you to rubber-stamp

**The test**: "What would I need to believe to decide right now?" If you can't
answer, you need more information or clarity.

## Trade-off Analysis

Every decision is a trade-off. Make them explicit.

| Trade-off Frame       | Question                                         |
| --------------------- | ------------------------------------------------ |
| **Speed vs quality**  | How much technical debt can we afford?           |
| **Now vs later**      | Is this the right time, or are we forcing it?    |
| **Scope vs schedule** | What can we cut to hit the date?                 |
| **Local vs global**   | Does this help my team but hurt the org?         |
| **Reversible vs not** | Can we undo this if we're wrong?                 |
| **Known vs unknown**  | Are we optimizing for what we know or exploring? |

**The discipline**: Write down what you're trading away. If you can't name it,
you haven't decided—you've avoided.

## Technical Judgment

The synthesis of experience, principles, and context.

### What It Looks Like

- Knowing when the "right" solution is wrong for this situation
- Seeing second-order effects before they happen
- Distinguishing essential complexity from accidental complexity
- Knowing when to go deep vs ship and iterate
- Pattern-matching without over-applying patterns

### How It Develops

| Stage          | Behavior                                       |
| -------------- | ---------------------------------------------- |
| **Novice**     | Follows rules rigidly                          |
| **Competent**  | Applies rules with context                     |
| **Proficient** | Recognizes patterns, deviates when appropriate |
| **Expert**     | Intuition guided by principles                 |

**The gap**: No one teaches judgment directly. You build it through reps,
reflection, and feedback on decisions over time.

## Delegation

Not every decision is yours to make.

| Delegate When                      | Decide Yourself When                |
| ---------------------------------- | ----------------------------------- |
| Someone is closer to the problem   | You have context others lack        |
| It's a growth opportunity for them | The stakes require your judgment    |
| The decision is reversible         | Speed matters and you're fastest    |
| You're a bottleneck                | It's explicitly your accountability |
| You want to build their judgment   | Delegation would be abdication      |

### Escalate When

- The decision affects multiple teams with competing interests
- You lack authority to commit resources
- You've tried peer resolution and failed
- The risk exceeds your mandate
- Someone wants you to decide something political

**The balance**: Decide too much → bottleneck. Decide too little → abdication.
Calibrate to context.

## Disagreement

Good decisions require productive conflict. See [Disagreement](disagreement.md)
for the full treatment—Graham's hierarchy, disagree-and-commit, navigating power
dynamics, and structural techniques.

## Decision Documentation

Decisions are invisible unless captured. Future you (and future teammates) need
context.

### What to Capture

| Element             | Purpose                                |
| ------------------- | -------------------------------------- |
| **Context**         | What situation prompted this decision? |
| **Options**         | What alternatives did you consider?    |
| **Decision**        | What did you choose?                   |
| **Rationale**       | Why this option over others?           |
| **Trade-offs**      | What did we give up?                   |
| **Stakeholders**    | Who did you consult? Who decided?      |
| **Revisit trigger** | When would we reconsider?              |

### Lightweight ADR Template

```markdown
# [Decision Title]

## Status

Accepted | Superseded | Deprecated

## Context

What's the situation? What forces are at play?

## Decision

What are we doing?

## Consequences

What trade-offs are we accepting?
```

### When to Document

- One-way doors
- Decisions others will question later
- Anything you've debated more than once
- Reversals of previous decisions

**The payoff**: Documentation isn't bureaucracy. It's leverage—future decisions
build on past reasoning.

## Sunk Cost and Quitting

### Signs It's Time to Quit

- The original rationale no longer holds
- You're continuing because you've already invested, not because it's right
- Opportunity cost exceeds potential gain
- You're the only one who still believes
- New information invalidates the premise

### Why Quitting Is Hard

- Identity attachment ("I championed this")
- Loss aversion (losses feel 2x worse than gains)
- Sunk cost fallacy ("but we've already spent...")
- Social pressure ("everyone's counting on this")

### How to Quit Well

- Name what you learned
- Communicate the decision clearly
- Reallocate resources visibly
- Don't relitigate—move forward

**Kill criteria**: Define upfront what would make you stop. When those
conditions arrive, stop.

## Calibration

Knowing when you're right and when you're wrong.

### Signs You're Well-Calibrated

- Your confidence matches your accuracy
- You update beliefs when presented with evidence
- You can articulate what would change your mind
- You distinguish "I don't know" from "I have a hunch"

### Signs You're Miscalibrated

- Frequently surprised by outcomes
- Defensive when challenged
- Can't remember being wrong recently
- Every decision feels certain

### How to Improve

- Track predictions and outcomes
- Seek disconfirming evidence
- Ask "What would I expect to see if I were wrong?"
- Debrief decisions regardless of outcome

**The humility**: Overconfidence is the default. Calibration requires active
effort.

## Common Traps

| Trap                     | Pattern                                   | Fix                            |
| ------------------------ | ----------------------------------------- | ------------------------------ |
| **Analysis paralysis**   | Waiting for perfect information           | Set a decision deadline        |
| **Bike-shedding**        | Debating trivia while ignoring hard stuff | Start with the scary decision  |
| **HiPPO**                | Highest-paid person's opinion wins        | Seek dissent explicitly        |
| **Groupthink**           | Consensus without genuine agreement       | Assign a devil's advocate      |
| **Recency bias**         | Over-weighting recent events              | Look at base rates             |
| **Confirmation bias**    | Seeking evidence that supports your view  | Seek disconfirming evidence    |
| **Sunk cost**            | Continuing because you've invested        | Ask: would I start this today? |
| **Premature commitment** | Deciding before understanding             | Explore before exploiting      |

## Questions to Ask

### Before Deciding

- Is this my decision to make?
- What type of door is this? (one-way, two-way, sliding)
- What am I trading off?
- What would change my mind?
- Who do I need to consult vs inform?

### After Deciding

- Did I document the rationale?
- Does everyone know the decision?
- What's the revisit trigger?
- What would I do differently next time?

### Periodically

- What decisions am I avoiding?
- Where am I a bottleneck?
- What did I get wrong recently? What did I learn?
- Am I delegating enough? Too much?

---

_"The best decision is the right decision. The second best is the wrong
decision. The worst is no decision."_ — attributed to various
