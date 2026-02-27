# The Goodhart Method

When a measure becomes a target, it ceases to be a good measure. A method for
detecting proxy corruption before the metric replaces the goal.

## What Goodhart Analysis Is / Isn't

| Goodhart Analysis Is                                      | Goodhart Analysis Isn't                       |
| --------------------------------------------------------- | --------------------------------------------- |
| Questioning whether the metric still tracks the goal      | Arguing against measurement                   |
| Finding where the proxy has drifted from reality          | Claiming all metrics are useless              |
| Naming the specific corruption mechanism                  | Vague distrust of numbers                     |
| Checking if optimization changed the thing being measured | Rejecting quantitative evidence               |
| Asking what behavior the metric actually incentivizes     | Asking whether the number went up or down     |
| Protecting the goal from its own instrument               | Protecting the status quo from accountability |

**The test:** Can you name what the metric was supposed to measure, what it
actually measures now, and the specific mechanism that caused the drift? If not,
you haven't done Goodhart analysis -- you've expressed skepticism.

## Why It Works

Goodhart analysis is defensive, not anti-metric. It protects the goal by
auditing its instruments.

| Benefit                         | Mechanism                                                                   |
| ------------------------------- | --------------------------------------------------------------------------- |
| **Preserves original intent**   | Forces you to name the goal before examining the metric                     |
| **Catches corruption early**    | Identifies drift before the proxy fully replaces the goal                   |
| **Reveals perverse incentives** | Names the behavior the metric actually rewards vs. what it claims to reward |
| **Prevents McNamara Fallacy**   | Surfaces what the metric cannot see -- the qualitative residue it drops     |
| **Sharpens metric design**      | A metric that survives Goodhart analysis is a better metric                 |

## The Corruption Mechanisms

Four ways a measure stops measuring what it claims. Adapted from Strathern
(1997) and Manheim & Garrabrant (2019).

| Mechanism       | Pattern                                                                | Example                                                                    |
| --------------- | ---------------------------------------------------------------------- | -------------------------------------------------------------------------- |
| **Regressing**  | Metric correlates with goal, but optimizing it doesn't                 | Lines of code correlates with features; maximizing it creates bloat        |
| **Extremal**    | Optimization finds edge cases the designer didn't model                | Highest test coverage comes from trivial assertions, not real tests        |
| **Causal**      | Metric and goal share a cause; moving the metric doesn't move the goal | Hiring from top schools correlates with talent; the school isn't the cause |
| **Adversarial** | Agents game the metric once it becomes a target                        | Code review velocity rises because reviewers stop reading carefully        |

## The Method

### Step 1: Name the Goal

What were you trying to achieve before you chose a metric? State the goal in
terms of outcomes, not numbers. "Ship reliable software" not "achieve 95%
coverage."

### Step 2: Name the Proxy

What metric stands in for the goal? Every metric is a proxy. Name the gap
between what the proxy measures and what the goal requires.

### Step 3: Identify the Optimization Pressure

Who or what optimizes for this metric? Humans gaming incentives, algorithms
maximizing a loss function, teams reporting to dashboards. The optimizer
determines the corruption mechanism.

### Step 4: Check Each Corruption Mechanism

For each of the four mechanisms, ask:

- **Regressing:** Does improving this metric still improve the goal, or has the
  correlation broken?
- **Extremal:** Has optimization found edge cases that satisfy the metric but
  miss the goal?
- **Causal:** Does the metric cause the goal, or do they share an upstream
  cause?
- **Adversarial:** Has anyone changed behavior to optimize the metric rather
  than the goal?

### Step 5: Prescribe

Three options:

1. **Keep the metric** -- corruption is minimal, proxy still tracks the goal
2. **Repair the metric** -- add guards against the specific corruption found
3. **Replace the metric** -- proxy has drifted too far; name a better one

## Engineering Applications

| Context                    | What to Audit                                                           |
| -------------------------- | ----------------------------------------------------------------------- |
| **Test coverage**          | Does coverage measure confidence or ceremony? Trivial tests corrupt it. |
| **Sprint velocity**        | Does velocity measure throughput or story point inflation?              |
| **Code review turnaround** | Does speed measure efficiency or rubber-stamping?                       |
| **Deployment frequency**   | Does frequency measure capability or recklessness?                      |
| **Lines of code**          | Does volume measure productivity or verbosity?                          |
| **Token usage**            | Does token count measure thoroughness or bloat?                         |
| **Rework ratio**           | Does low rework mean quality or insufficient testing?                   |
| **Time-to-resolution**     | Does fast resolution mean skill or premature closure?                   |

## Common Traps

| Trap                               | Pattern                                                           | Fix                                                             |
| ---------------------------------- | ----------------------------------------------------------------- | --------------------------------------------------------------- |
| **Metric nihilism**                | "All metrics are gamed, so don't measure"                         | Goodhart says fix the proxy, not abandon measurement            |
| **Metric multiplication**          | Adding metrics to cover every gap until the dashboard is noise    | Fewer metrics with Goodhart checks beat many metrics unchecked  |
| **Lagging indicators only**        | Measuring what happened, never what's happening                   | Pair lagging indicators with leading ones                       |
| **Survivor bias in metrics**       | Measuring what succeeded, not what was filtered out               | Ask what the metric cannot see                                  |
| **Goodharting the Goodhart check** | Turning "we do Goodhart analysis" into a compliance checkbox      | If you can't name the corruption mechanism, you haven't checked |
| **Proxy worship**                  | Forgetting the metric was ever a proxy -- treating it as the goal | Regularly restate the goal in non-metric terms                  |

## Questions

### Before Analysis

- What is the actual goal, stated without numbers?
- When was this metric chosen, and what assumption connected it to the goal?
- Who optimizes for this metric, and what do they gain?

### During Analysis

- Which corruption mechanism is most active?
- Has the correlation between metric and goal been tested recently?
- What behavior does this metric reward that the goal does not?

### After Analysis

- Can the original advocate of this metric name what it misses?
- Is there a metric that's harder to game but still tracks the goal?
- What would we do differently if we couldn't measure this at all?

---

_"Not everything that counts can be counted, and not everything that can be
counted counts."_ -- William Bruce Cameron
