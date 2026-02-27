# Architecture

Systems outlast intentions. What you build constrains what others can build.

## What Architecture Is

| Architecture Is                        | Architecture Isn't     |
| -------------------------------------- | ---------------------- |
| Decisions that are hard to change      | Implementation details |
| Constraints that shape solutions       | The solution itself    |
| Structure that enables or prevents     | One-time documentation |
| Trade-offs with long-term consequences | Getting it "right"     |

**The test:** If it would take significant effort to undo, it's architecture.

## Architectural Thinking

### The Core Questions

| Question                              | What It Reveals             |
| ------------------------------------- | --------------------------- |
| "What's the hardest thing to change?" | Where architecture lives    |
| "What are we optimizing for?"         | Core trade-offs             |
| "What can we defer?"                  | What isn't architecture yet |
| "What breaks if this grows 10x?"      | Scalability assumptions     |
| "Who else depends on this?"           | Coupling and contracts      |

### Thinking in Trade-offs

Every architectural decision trades something for something else.

| You Get     | You Give Up                |
| ----------- | -------------------------- |
| Consistency | Availability (CAP theorem) |
| Simplicity  | Flexibility                |
| Performance | Abstraction                |
| Decoupling  | Coordination overhead      |
| Type safety | Development speed          |

**The discipline:** Name the trade-off explicitly. "We chose X, which means
we're accepting Y."

### Time Horizons

| Horizon | Focus          | Stability                |
| ------- | -------------- | ------------------------ |
| Days    | Implementation | Can change freely        |
| Weeks   | Design         | Can change with effort   |
| Months  | Architecture   | Expensive to change      |
| Years   | Platform       | Defines the organization |

Good architecture decisions should remain valid for their intended horizon.

## Structural Integrity

### Signs of Good Structure

| Signal                     | Indicates             |
| -------------------------- | --------------------- |
| Changes stay localized     | Good boundaries       |
| New features fit naturally | Extendable design     |
| Failures stay contained    | Proper isolation      |
| Code is discoverable       | Coherent organization |
| Onboarding is quick        | Clear mental model    |

### Signs of Structural Decay

| Signal                          | Indicates          |
| ------------------------------- | ------------------ |
| Every change touches many files | Poor boundaries    |
| "Just add it here for now"      | Accumulating cruft |
| Mysterious failures cascade     | Hidden coupling    |
| Only one person understands it  | Knowledge silos    |
| Fear of touching certain areas  | Technical debt     |

**The trap:** Decay is invisible until it's expensive. Small compromises
compound.

## Managing Technical Debt

### Debt Is Normal

Technical debt isn't failure—it's a financing decision. The problem is
_untracked_ debt.

| Intentional Debt                 | Unintentional Debt               |
| -------------------------------- | -------------------------------- |
| "We'll hardcode this for launch" | "Oops, this became load-bearing" |
| Tracked, planned paydown         | Discovered during crisis         |
| Conscious trade-off              | Unconscious accumulation         |

### Debt Assessment

| Dimension         | Question                          |
| ----------------- | --------------------------------- |
| **Interest rate** | How much is this slowing us down? |
| **Principal**     | How much effort to pay it off?    |
| **Risk**          | What breaks if we don't pay?      |
| **Visibility**    | Do we know where the debt is?     |

**Prioritize:** High interest rate + high risk. Ignore: Low interest + low risk.

### Paying Down Debt

| Strategy              | When to Use                                      |
| --------------------- | ------------------------------------------------ |
| **Boy scout rule**    | Leave it better than you found it, incrementally |
| **Dedicated sprints** | Debt has become blocking                         |
| **Rewrite**           | Debt exceeds value of existing code              |
| **Contain**           | Can't fix yet, but limit the spread              |

**The trap:** Rewrites rarely work. Prefer incremental improvement unless the
system is truly unsalvageable.

## Preventing Drift

### How Drift Happens

1. Exception becomes pattern
2. Pattern becomes expectation
3. Expectation becomes "how we do things"
4. Everyone forgets the original intention

**The fix:** Document _why_, not just _what_. Future maintainers need context.

### Mechanisms for Consistency

| Mechanism                         | What It Enforces       |
| --------------------------------- | ---------------------- |
| **Linters/formatters**            | Style consistency      |
| **Type systems**                  | Interface contracts    |
| **CI checks**                     | Quality gates          |
| **Architecture Decision Records** | Rationale preservation |
| **Templates/generators**          | Structural patterns    |
| **Code review**                   | Human judgment on fit  |

### When to Say No

Drift happens through accumulated "small exceptions." Saying no is expensive but
necessary.

| Say No When                                 | Because                      |
| ------------------------------------------- | ---------------------------- |
| "Just this once"                            | It's never just once         |
| Shortcut violates a core principle          | Principles exist for reasons |
| Exception requires hiding complexity        | Complexity will resurface    |
| Pattern would be embarrassing if widespread | It will spread               |

**The balance:** Too rigid → slow, frustrating. Too flexible → chaos. Enforce
the few things that matter most.

## Documentation

### What to Document

| Document                          | Why                     | Update Frequency       |
| --------------------------------- | ----------------------- | ---------------------- |
| **Architecture Decision Records** | Why we chose this       | When decisions change  |
| **System overview**               | How pieces fit together | When structure changes |
| **API contracts**                 | What others depend on   | When interfaces change |
| **Runbooks**                      | How to operate          | When operations change |

### What Not to Document

- Anything code can express
- Anything that will immediately go stale
- Implementation details (they change)
- Obvious things

**The test:** Would someone six months from now need this to understand or
operate the system?

## Common Traps

| Trap                           | Pattern                            | Fix                                  |
| ------------------------------ | ---------------------------------- | ------------------------------------ |
| **Astronaut architecture**     | Over-abstraction for hypotheticals | Build for today, design for tomorrow |
| **Resume-driven architecture** | Choosing tech for career, not fit  | Boring technology that works         |
| **Second system effect**       | Over-engineering the rewrite       | Constrain scope ruthlessly           |
| **Golden hammer**              | Using familiar solution everywhere | Right tool for each job              |
| **Analysis paralysis**         | Perfect design before building     | Iterate: build, learn, refine        |
| **Invisible architecture**     | Decisions live only in heads       | Write it down                        |

## Questions to Ask

### When Designing

- What are we optimizing for?
- What are we explicitly _not_ optimizing for?
- What's the hardest thing to change later?
- How does this fail?
- Who will maintain this after me?

### When Inheriting

- Why is it structured this way?
- What constraints shaped these decisions?
- What would I do differently, and should I?
- Where are the bodies buried?

### Periodically

- Is our architecture still serving us?
- What decisions would we make differently today?
- Where is drift accumulating?
- What documentation is stale?

---

_"Architecture is the decisions you wish you could get right early."_ — Ralph
Johnson
