# Exploration

The elegant path exists. Your job is to find it before committing resources.

## The Exploration Mindset

| Execution Mode       | Exploration Mode    |
| -------------------- | ------------------- |
| Minimize uncertainty | Embrace uncertainty |
| Follow the plan      | Discover the plan   |
| Optimize known path  | Find better paths   |
| Depth-first          | Breadth-first       |
| Commit early         | Commit late         |

**The trap:** Treating exploration like execution. Exploring with a deadline.
Optimizing before understanding.

## When to Explore

### Explore First

- New domain, unfamiliar technology
- Requirements are ambiguous or contradictory
- Multiple viable approaches exist
- Stakes are high and reversibility is low
- You're pattern-matching to something that feels wrong

### Execute Directly

- Well-understood problem space
- Clear requirements, proven approach
- Low stakes or easily reversible
- Time pressure with acceptable risk
- You've done this before and conditions haven't changed

**The test:** Can you articulate the trade-offs of at least two approaches? If
not, you haven't explored enough.

## Exploration Techniques

### Breadth-First Survey

Before going deep, go wide.

| Technique                | When to Use                         |
| ------------------------ | ----------------------------------- |
| **Skim documentation**   | New library or framework            |
| **Read existing code**   | Joining a codebase                  |
| **Talk to people**       | Organizational or political terrain |
| **Search for prior art** | Someone's probably solved this      |
| **List all options**     | Before evaluating any               |

**The discipline:** Resist the urge to commit to the first viable option. First
viable ≠ best.

### Spike Development

Cheap experiments to answer specific questions.

| Good Spike              | Bad Spike                |
| ----------------------- | ------------------------ |
| Has a clear question    | "Let's see what happens" |
| Time-boxed              | Open-ended               |
| Throwaway code expected | Becomes production code  |
| Tests one hypothesis    | Boils the ocean          |
| Informs a decision      | Postpones a decision     |

**Structure:**

1. State the question explicitly
2. Define what "answered" looks like
3. Set a time box (hours, not days)
4. Build the minimum to answer
5. Document findings, delete code

### Constraint Mapping

Understand the shape of the problem before solving it.

| Constraint Type    | Questions to Ask                                     |
| ------------------ | ---------------------------------------------------- |
| **Technical**      | What must this integrate with? What can't change?    |
| **Business**       | What's the deadline? What's the budget? Who decides? |
| **Organizational** | Who needs to approve? Who will resist?               |
| **Physical**       | Latency limits? Storage limits? User geography?      |

**The move:** Constraints are information, not obstacles. They narrow the
solution space, which helps.

## Navigating Ambiguity

### Levels of Uncertainty

| Level           | What You Know                       | Strategy                 |
| --------------- | ----------------------------------- | ------------------------ |
| **Clear**       | Problem and solution known          | Execute                  |
| **Complicated** | Problem known, solution unclear     | Analyze, consult experts |
| **Complex**     | Problem unclear, cause/effect fuzzy | Probe, sense, respond    |
| **Chaotic**     | No clear cause/effect               | Act, sense, respond      |

Most interesting problems are complex, not complicated. Analysis won't resolve
them -- experimentation will.

### Questions That Clarify

| Question                         | What It Surfaces                     |
| -------------------------------- | ------------------------------------ |
| "What would we need to believe?" | Hidden assumptions                   |
| "What's the simplest version?"   | Essential vs. accidental complexity  |
| "What would make this easy?"     | Constraints that might be negotiable |
| "What would failure look like?"  | Risks and edge cases                 |
| "Who's done this before?"        | Prior art, people to consult         |

### When You're Stuck

1. **Change altitude** -- Zoom out (bigger context) or zoom in (specific detail)
2. **Change medium** -- Whiteboard, walk, talk to someone
3. **Invert the problem** -- What would make this impossible?
4. **Time-box the stuckness** -- 30 more minutes, then escalate or pivot

## Learning New Domains

### The Learning Curve

| Phase           | Focus                                | Output               |
| --------------- | ------------------------------------ | -------------------- |
| **Orientation** | Vocabulary, concepts, key players    | Mental map           |
| **Imitation**   | Follow tutorials, copy examples      | Working code         |
| **Adaptation**  | Modify examples for your needs       | Customized solutions |
| **Innovation**  | Combine, extend, create new patterns | Expertise            |

**The trap:** Skipping orientation. You'll build faster initially but make
structural mistakes.

### Efficient Learning

| Do                                | Don't                         |
| --------------------------------- | ----------------------------- |
| Read the "Getting Started" guide  | Read the entire documentation |
| Build something small immediately | Study theory before practice  |
| Break things intentionally        | Stay in the safe path         |
| Ask dumb questions early          | Pretend you understand        |
| Find the community/experts        | Figure everything out alone   |

**The test:** Can you explain it to someone else? If not, you don't understand
it.

## Common Traps

| Trap                      | Pattern                                  | Fix                                          |
| ------------------------- | ---------------------------------------- | -------------------------------------------- |
| **Analysis paralysis**    | Exploring forever, never committing      | Time-box exploration, set decision deadlines |
| **Premature commitment**  | Committing before understanding          | Force yourself to list alternatives          |
| **Sunk cost exploration** | Continuing bad path because invested     | Set kill criteria upfront                    |
| **Shiny object syndrome** | Distracted by interesting tangents       | Return to the question you're answering      |
| **Expert blindness**      | Assuming your domain expertise transfers | Adopt beginner's mind in new territory       |
| **Solo exploration**      | Not leveraging others' knowledge         | Ask who's been here before                   |

## Questions to Ask

### Before Exploring

- What question am I trying to answer?
- How will I know when I've answered it?
- What's my time budget for this?
- Who might already know the answer?

### During Exploration

- Am I going deep too early?
- Have I considered alternatives?
- What assumptions am I making?
- What would change my mind?

### After Exploring

- What did I learn?
- What's the recommended path and why?
- What are the trade-offs I'm accepting?
- What questions remain?

## What Comes Next

Exploration surfaces options. [Pathfinding](pathfinding.md) evaluates them --
scoring against forces, naming trade-offs, and checking reversibility. One-way
doors produce [decision records](decisions.md) that preserve the reasoning for
the next person at the same fork.

```text
Exploration ──> Pathfinding ──> Decision Record
  (survey)       (evaluate)       (preserve)
```

---

_"If I had an hour to solve a problem, I'd spend 55 minutes thinking about the
problem and 5 minutes thinking about solutions."_ -- attributed to Einstein
