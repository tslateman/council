# Pathfinding

The right path reveals itself through structured elimination, not inspiration.

## What Pathfinding Is

| Pathfinding Is                                   | Pathfinding Isn't                       |
| ------------------------------------------------ | --------------------------------------- |
| Structured comparison of viable approaches       | Brainstorming without constraints       |
| Elimination through named trade-offs             | Picking the first option that works     |
| Mapping the decision to its reversibility        | Treating every choice with equal weight |
| Producing a recommendation with dissent recorded | Achieving consensus before acting       |

**The test:** Can you name what you're giving up with each option? If you can't
articulate the trade-off, you haven't pathfound -- you've guessed.

## When to Pathfind

| Situation                           | Action                                      |
| ----------------------------------- | ------------------------------------------- |
| One viable option exists            | Execute. Pathfinding wastes time here.      |
| Two to four options exist           | Pathfind. This is the sweet spot.           |
| More than four options exist        | Constrain first. Too many options = missing |
|                                     | constraints. Return to [exploration].       |
| Options look equivalent             | Find the dimension where they differ.       |
| Strong gut preference, weak reasons | Pathfind to confirm or challenge the gut.   |

[exploration]: exploration.md

## The Evaluation Framework

### Step 1: Name the Forces

Before comparing options, name what pulls the decision in each direction. Forces
are constraints, goals, and pressures -- not options.

| Force Type | Examples                                             |
| ---------- | ---------------------------------------------------- |
| **Hard**   | Must integrate with X. Budget is Y. Ships by Z.      |
| **Soft**   | Team prefers TypeScript. Existing patterns use TOML. |
| **Latent** | We haven't tested at scale. Users haven't asked yet. |

**The discipline:** Hard forces eliminate options. Soft forces rank survivors.
Latent forces become spikes. Mixing these three produces analysis paralysis.

### Step 2: Score Against Forces

| Option      | Hard Force A | Hard Force B | Soft Force C | Soft Force D | Survives? |
| ----------- | ------------ | ------------ | ------------ | ------------ | --------- |
| **Alpha**   | Pass         | Pass         | Strong       | Weak         | Yes       |
| **Bravo**   | Pass         | **Fail**     | Strong       | Strong       | **No**    |
| **Charlie** | Pass         | Pass         | Weak         | Strong       | Yes       |

Hard forces produce binary pass/fail. Any hard failure eliminates the option.
Soft forces produce relative ranking among survivors.

### Step 3: Name the Trade-off

Every surviving option trades something for something else. Make it explicit.

| We Choose | Over    | Because                                  |
| --------- | ------- | ---------------------------------------- |
| **Alpha** | Charlie | Soft Force C matters more than D because |
|           |         | [concrete reason]                        |

"Because" must contain a reason, not a preference. "We like it better" is not a
reason. "It reduces the integration surface from three contracts to one" is.

### Step 4: Check Reversibility

| Reversibility | Characteristics                       | Required Rigor         |
| ------------- | ------------------------------------- | ---------------------- |
| **Two-way**   | Easy to undo. Low switching cost.     | Decide fast, document. |
| **One-way**   | Hard to reverse. High switching cost. | Invoke Critic +        |
|               | Commits the team for months.          | Marshal. Record ADR.   |
| **Trapdoor**  | Invisible one-way. Looks reversible   | Surface the trapdoor   |
|               | until you try to reverse it.          | before committing.     |

**The trap:** Trapdoor decisions. Choosing a data format feels reversible until
migration scripts touch every consumer. Choosing a CLI framework feels
reversible until plugins depend on its extension points. Surface trapdoors by
asking: "What would reversal actually require?"

## Technology Evaluation

When pathfinding involves choosing a technology -- library, framework, tool,
language -- apply additional lenses.

### Fitness Dimensions

| Dimension          | Question                                         |
| ------------------ | ------------------------------------------------ |
| **Fit to problem** | Does it solve the actual problem, or an adjacent |
|                    | one?                                             |
| **Fit to team**    | Can the team operate it without heroics?         |
| **Fit to stack**   | Does it compose with what exists, or require a   |
|                    | parallel ecosystem?                              |
| **Fit to future**  | Will it still serve in 18 months, or are we      |
|                    | adopting at peak hype?                           |

**The test:** A technology that scores high on fit-to-problem but low on
fit-to-stack creates a seam. Every seam accumulates maintenance cost forever.

### Hype vs. Signal

| Signal                                        | Hype                                    |
| --------------------------------------------- | --------------------------------------- |
| Solves a problem you measured                 | Solves a problem you read about         |
| Adopted by teams with your constraints        | Adopted by teams with different context |
| Has survived one hype cycle                   | Currently in its first hype cycle       |
| Documentation covers failure modes            | Documentation covers only happy paths   |
| You can articulate what you'd lose without it | You can only articulate what you'd gain |

## Spike Integration

Pathfinding sometimes stalls because two options look equivalent on paper. When
scoring can't separate them, a spike breaks the tie.

| Pathfinding State         | Action                                 |
| ------------------------- | -------------------------------------- |
| Clear winner from scoring | Recommend. Skip the spike.             |
| Two options within margin | Spike the differentiating dimension.   |
| No option survives forces | Reframe. The options or the forces are |
|                           | wrong. Return to [exploration].        |

Spike protocol lives in [exploration](exploration.md#spike-development). The
spike answers one question -- the dimension where the options diverged.

## Common Traps

| Trap                       | Pattern                                        | Fix                                          |
| -------------------------- | ---------------------------------------------- | -------------------------------------------- |
| **Skipping forces**        | Comparing options without naming constraints   | List forces before listing options           |
| **Soft force as hard**     | "Team prefers X" treated as elimination        | Preferences rank; constraints eliminate      |
| **Missing trade-off name** | Recommending without stating what's sacrificed | Every recommendation carries a "We chose X   |
|                            |                                                | over Y because Z" sentence                   |
| **Reversibility theater**  | "We can always switch" without costing it      | Estimate reversal cost in hours or contracts |
| **Dimension collapse**     | Evaluating only one axis (e.g., performance)   | Require at least three fitness dimensions    |
| **Novelty bias**           | New option evaluated more favorably than known | Apply same rigor to new and existing options |

## Questions to Ask

### Before Pathfinding

- What forces constrain this decision? Which are hard vs. soft?
- How many options survive the hard forces?
- Is this a one-way door, a two-way door, or a trapdoor?
- Who else has context on this decision?

### During Pathfinding

- Am I scoring against forces, or against preferences?
- Can I name the trade-off for each surviving option?
- Is a spike needed, or does the scoring already separate the options?
- What would the Critic say about my recommendation?

### After Pathfinding

- Did the recommendation produce an ADR? (One-way doors require one.)
- Did I record the dissent -- the case for the option I rejected?
- Can someone reading only the trade-off table understand the decision?
- What would reopen this decision?

---

_"The essence of strategy is choosing what not to do."_ -- Michael Porter
