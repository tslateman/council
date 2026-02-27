# Critique

Doubt is a tool, not a disposition.

## What Critique Is / Isn't

| Critique Is                            | Critique Isn't                    |
| -------------------------------------- | --------------------------------- |
| Testing claims against evidence        | Tearing things down               |
| Searching for flaws before they ship   | Searching for flaws to feel smart |
| Strengthening ideas through challenge  | Weakening people through attack   |
| Exposing assumptions so they're chosen | Exposing mistakes to assign blame |
| Proportional to stakes                 | Applied uniformly to everything   |

**The test:** After your critique, is the idea stronger? If not, you're
criticizing, not critiquing.

## Rapoport's Rules

Before you rebut, earn the right. Dennett's formulation of Rapoport's protocol:

1. **Restate** the position so clearly that the author says "Yes, exactly"
2. **List points of agreement**, especially uncommon or non-obvious ones
3. **Name what you learned** from the position
4. **Then, and only then**, state your rebuttal

**The discipline:** Steps 1-3 force genuine engagement. Skip them and you're
arguing against a straw man -- even if you don't intend to. See
[Steelman](steelman.md) for the full method and [Disagreement](disagreement.md)
for Graham's hierarchy.

## The Skeptic's Toolkit

Adapted from Sagan's Baloney Detection Kit (_The Demon-Haunted World_, 1995),
reframed for engineering arguments.

| Tool                         | Question It Asks                                        |
| ---------------------------- | ------------------------------------------------------- |
| **Independent verification** | Can someone else reproduce this result?                 |
| **Substantive debate**       | Has the claim survived challenge from informed critics? |
| **Multiple hypotheses**      | Are we testing alternatives or confirming a favorite?   |
| **Falsifiability**           | What evidence would prove this wrong?                   |
| **Chain of reasoning**       | Does every step follow? Any logical gaps?               |
| **Occam's Razor**            | Is a simpler explanation sufficient?                    |
| **Measurability**            | Can the claim produce testable predictions?             |

**How to apply:** Pick two or three tools per argument. Applying all seven to
every claim is paranoia, not skepticism.

## Feynman's First Principle

> "The first principle is that you must not fool yourself -- and you are the
> easiest person to fool."
>
> -- Richard Feynman, "Cargo Cult Science" (1974)

Self-deception is the primary risk. Every other bias flows from willingness to
believe comfortable explanations over true ones.

### Cargo Cult Patterns in Engineering

| Cargo Cult Pattern                  | What's Missing                                                    |
| ----------------------------------- | ----------------------------------------------------------------- |
| Adopting a framework without axioms | Understanding why it works here                                   |
| Copying architecture from big tech  | Their constraints, scale, and trade-offs                          |
| Writing tests that always pass      | Falsifiability -- testing what can break                          |
| Post-hoc justification of decisions | Honest confrontation of the real reason                           |
| Metrics that only go up             | Willingness to measure what matters (see [Goodhart](goodhart.md)) |

**WYSIATI** (Kahneman's "What You See Is All There Is"): We build models from
available evidence and forget evidence we haven't seen. The engineer who only
reads success stories sees a world where every launch succeeds.

**The test:** Can you name what you're ignoring? If not, you're inside WYSIATI.

## Cognitive Bias Field Guide

Biases most dangerous in engineering critique. Sources: Kahneman (_Thinking,
Fast and Slow_, 2011) and Munger ("Psychology of Human Misjudgment").

| Bias               | How It Distorts Critique                      | Counter                             |
| ------------------ | --------------------------------------------- | ----------------------------------- |
| **Confirmation**   | Seek evidence supporting your initial view    | Seek disconfirming evidence first   |
| **Anchoring**      | First number or proposal dominates evaluation | Generate your own estimate first    |
| **Availability**   | Recent or vivid failures override base rates  | Ask for data, not anecdotes         |
| **Survivorship**   | Only visible successes inform judgment        | Study the failures that disappeared |
| **Sunk cost**      | Past investment justifies continued spending  | Ask: would I start this today?      |
| **WYSIATI**        | Confidence from incomplete information        | Name what evidence is missing       |
| **Overconfidence** | Certainty exceeds accuracy                    | Calibrate with prediction tracking  |
| **Authority**      | Rank substitutes for evidence                 | Evaluate the argument, not the rank |
| **Status quo**     | Default option gets unearned advantage        | Make the default compete equally    |
| **Dunning-Kruger** | Low skill produces high confidence            | Test your model against reality     |

**The discipline:** You don't beat biases through awareness alone. You beat them
through process -- checklists, structured techniques, external review.

## Debiasing Techniques

Knowing the bias is half the work. These techniques create enough friction to
interrupt automatic thinking.

| Technique                 | Source             | How It Works                                               |
| ------------------------- | ------------------ | ---------------------------------------------------------- |
| **Consider the opposite** | Larrick (2004)     | Ask "What if the opposite were true?" before evaluating    |
| **Prospective hindsight** | Klein (2007)       | Assume the project failed; work backward to find causes    |
| **Inversion**             | Munger             | Instead of "how do we succeed?", ask "how do we fail?"     |
| **Red team**              | Military doctrine  | Independent group attacks the proposal                     |
| **Pre-mortem**            | Klein (2007)       | Team imagines failure, each writes one cause independently |
| **Base rate check**       | Kahneman/Tversky   | Before trusting this case, check: how often does X happen? |
| **Devil's advocate**      | Catholic tradition | Assign someone to argue the strongest opposing case        |

### Pre-Mortem Protocol

Klein's pre-mortem leverages prospective hindsight -- people are better at
explaining past events than predicting future ones.

1. "Imagine it's six months from now. This project has failed."
2. Each person independently writes one plausible cause of failure
3. Collect and discuss -- no defending, only exploring
4. Prioritize the most likely and most dangerous causes
5. Decide which to mitigate, which to accept

**Why it works:** "Imagine it failed" bypasses optimism bias. "Write
independently" prevents groupthink. The combination surfaces risks that group
discussion suppresses.

## Logical Fallacies

Common fallacies in engineering arguments. Adapted from Sagan's list and
Aristotle's _Sophistical Refutations_.

| Fallacy                  | Pattern                                              | Example                                               |
| ------------------------ | ---------------------------------------------------- | ----------------------------------------------------- |
| **Ad hominem**           | Attack the person, not the argument                  | "You've never built a distributed system"             |
| **Appeal to authority**  | "The VP wants it" as if that settles the question    | Rank isn't evidence                                   |
| **Appeal to popularity** | "Everyone uses X" as proof of quality                | Everyone used SOAP once too                           |
| **False dichotomy**      | Only two options presented when more exist           | "Rewrite or live with it"                             |
| **Slippery slope**       | "If we allow X, then Y, then Z"                      | Without evidence linking each step                    |
| **Moving goalposts**     | Changing success criteria after you present evidence | "But what about..." when you address each concern     |
| **Begging the question** | Assuming the conclusion in the premise               | "We need microservices because our system is complex" |
| **Post hoc**             | Correlation treated as causation                     | "We deployed Monday; it crashed Tuesday"              |
| **Appeal to tradition**  | "We've always done it this way"                      | Past practice isn't a reason                          |
| **No true Scotsman**     | Redefining terms to exclude counterexamples          | "That's not real Agile"                               |

**How to use this:** Name the pattern, not the person. "I think that's a false
dichotomy -- are there other options?" works. "You're being fallacious" doesn't.

## The Socratic Toolkit

Questioning exposes weak reasoning faster than assertion. Five question types
from the Socratic tradition:

| Type                     | Purpose                | Example                                                   |
| ------------------------ | ---------------------- | --------------------------------------------------------- |
| **Definitional**         | Clarify terms          | "When you say 'scalable', what specifically do you mean?" |
| **Assumption-surfacing** | Expose hidden premises | "What has to be true for this to work?"                   |
| **Evidence-probing**     | Test the foundation    | "How do we know that? What's the evidence?"               |
| **Implication-tracing**  | Follow consequences    | "If that's true, what else must be true?"                 |
| **Viewpoint-shifting**   | Challenge perspective  | "How would the on-call engineer see this?"                |

**The discipline:** Ask questions you don't already know the answer to. Socratic
questioning used to lead witnesses is manipulation, not critique.

## Accountability

Taleb's symmetry principle (_Skin in the Game_, 2018): the quality of a judgment
correlates with the judge's exposure to consequences.

| Pattern                      | Symptom                                    | Fix                                  |
| ---------------------------- | ------------------------------------------ | ------------------------------------ |
| **No skin in the game**      | Critic bears no cost if wrong              | Name who lives with the consequences |
| **Asymmetric downside**      | Decision-maker gets credit, team gets pain | Align incentives before deciding     |
| **Critique from the stands** | Loud opinions, no implementation work      | "Would you own the rollout?"         |
| **Credentialed immunity**    | Seniority shields bad judgment from review | Evaluate arguments, not titles       |

**The test:** Would you make the same critique if you had to implement the
result? If not, your critique may lack the constraint that reality provides.

See [Decisions](decisions.md) for trade-off analysis and decision quality
frameworks.

## Common Traps

| Trap                        | Pattern                                                          | Fix                                                |
| --------------------------- | ---------------------------------------------------------------- | -------------------------------------------------- |
| **Cynicism as skepticism**  | Rejecting everything feels like rigor                            | Skepticism seeks truth; cynicism assumes the worst |
| **Critique theater**        | Performing criticism to signal intelligence                      | Serve the idea, not your reputation                |
| **Weaponized doubt**        | Using critique to block decisions without proposing alternatives | Every "no" requires an alternative or acceptance   |
| **Lone contrarian**         | Disagreeing for identity, not evidence                           | Check: are you arguing from data or ego?           |
| **Perfectionism**           | No proposal survives because none is flawless                    | Good enough for the stakes and timeline            |
| **Anchoring on first flaw** | First issue found dominates the assessment                       | Complete the review before forming a verdict       |
| **Tone as substance**       | Dismissing valid points because delivery was rough               | Engage the argument, not the wrapping              |
| **Expertise blindness**     | Deep knowledge in one domain applied uncritically to another     | Calibrate confidence to the specific domain        |

## Questions

### Before Critiquing

- What are the stakes? Is deep critique warranted, or is this a two-way door?
- Can I restate the proposal well enough that its author would agree?
- What's my prior? Am I approaching this with genuine curiosity?
- Who bears the consequences of this decision?

### During Critique

- Am I testing the argument or attacking the person?
- Have I applied the skeptic's toolkit, or am I relying on gut reaction?
- What evidence would change my mind?
- Am I naming fallacies or just feeling discomfort?

### After Critiquing

- Is the idea stronger now? Did I add clarity?
- Did the author feel heard? (Rapoport's Rules)
- Was my confidence proportional to my evidence?
- What did I learn from their position?

---

_"The essence of the independent mind lies not in what it thinks, but in how it
thinks."_ -- Christopher Hitchens
