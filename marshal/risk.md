# Risk

Someone has to go first. The Marshal's job is to make that survivable.

## Risk vs. Uncertainty

| Risk                              | Uncertainty                        |
| --------------------------------- | ---------------------------------- |
| Known unknowns                    | Unknown unknowns                   |
| You can estimate probabilities    | You can't estimate probabilities   |
| Manage with mitigation            | Manage with resilience             |
| "There's a 20% chance of failure" | "We don't know what we don't know" |

**The trap:** Treating uncertainty like risk. You can't calculate your way
through genuine unknowns.

## Risk Assessment

### The Basic Framework

| Dimension         | Question                        |
| ----------------- | ------------------------------- |
| **Probability**   | How likely is this to happen?   |
| **Impact**        | How bad if it does?             |
| **Reversibility** | Can we undo it? At what cost?   |
| **Detectability** | Will we know if it's happening? |

**Risk = Probability × Impact**, but reversibility and detectability change your
response.

### Risk Matrix

```text
              Low Impact    High Impact
High Prob     Nuisance      Serious
Low Prob      Ignore        Plan for it
```

Most planning energy goes to low-probability, high-impact risks. Mitigate or
accept high-probability risks early.

### Questions to Surface Risk

| Question                           | What It Finds    |
| ---------------------------------- | ---------------- |
| "What could go wrong?"             | Obvious risks    |
| "What assumptions are we making?"  | Hidden risks     |
| "What happened last time?"         | Historical risks |
| "What would our critics say?"      | Blind spot risks |
| "What's the worst realistic case?" | Tail risks       |

## When to Proceed

### Go Forward

- You understand and accept the risk
- Mitigation plans cover serious risks
- Reversibility is high or cost of delay exceeds risk
- Team can handle known failure modes
- Stakeholders agree on acceptable risk

### Hold Back

- Risks aren't understood well enough to assess
- Mitigation plans don't exist for serious risks
- One-way door with insufficient analysis
- Team isn't prepared for likely failure modes
- Key stakeholders haven't accepted the risk

**The test:** Could you explain to your skip-level what could go wrong and why
you're proceeding anyway?

## Risk Mitigation Strategies

| Strategy     | When to Use                       | Example                          |
| ------------ | --------------------------------- | -------------------------------- |
| **Avoid**    | Risk too high, alternatives exist | Don't use unproven technology    |
| **Reduce**   | You can lower the risk affordably | Add monitoring, testing, reviews |
| **Transfer** | Someone else can bear the risk    | Insurance, SLAs, contracts       |
| **Accept**   | Risk is low or unavoidable        | Document and move on             |

### Reduce Blast Radius

| Technique            | How It Helps                      |
| -------------------- | --------------------------------- |
| **Feature flags**    | Turn off bad code without deploy  |
| **Gradual rollout**  | Limit exposure before full launch |
| **Circuit breakers** | Fail fast, prevent cascade        |
| **Rollback plans**   | Quick recovery from bad deploys   |
| **Monitoring**       | Detect problems early             |

**The discipline:** Blast radius reduction isn't paranoia—it's professionalism.
The question isn't if something will go wrong, but when.

## Decision-Making Under Pressure

### The Pressure Trap

| Under Pressure        | You Tend To              | Better Response              |
| --------------------- | ------------------------ | ---------------------------- |
| Fewer options visible | Rush to first solution   | Force 3 options minimum      |
| Tunnel vision         | Miss adjacent risks      | Zoom out briefly             |
| Short-term focus      | Ignore long-term costs   | Name what you're trading     |
| Defer to authority    | Stop thinking critically | Voice concerns once, clearly |

### The OODA Loop

1. **Observe** — What's actually happening? (Not what you expected)
2. **Orient** — What does this mean? (Update your mental model)
3. **Decide** — What's the action? (Pick one, don't waffle)
4. **Act** — Execute (Then observe again)

Speed through the loop beats perfection in any stage.

### When You Must Decide Now

| Do                          | Don't                          |
| --------------------------- | ------------------------------ |
| Use good-enough information | Wait for perfect information   |
| Make reversible choices     | Make permanent choices hastily |
| Communicate your reasoning  | Decide silently                |
| Set a follow-up checkpoint  | Fire and forget                |
| Prepare to be wrong         | Bet everything on being right  |

## Protecting the Team

### What Protection Looks Like

| Action                           | Why It Matters              |
| -------------------------------- | --------------------------- |
| Absorb uncertainty upward        | Team can focus on execution |
| Translate chaos into clarity     | They know what to do        |
| Take responsibility for failures | They take appropriate risks |
| Shield from thrash               | Productivity stays high     |
| Give credit for successes        | Trust compounds             |

### The Balance

- Protect too much → Team doesn't develop judgment
- Protect too little → Team burns out, stops taking risks

**The line:** Protect from _unfair_ pressure, not from _all_ pressure. Growth
requires challenge.

### Managing Up During Risk

| Principle                  | Application                                        |
| -------------------------- | -------------------------------------------------- |
| **No surprises**           | Communicate risks early, not when they materialize |
| **Options, not problems**  | Bring solutions alongside concerns                 |
| **Quantify when possible** | "30% chance of 2-week delay" beats "might be late" |
| **Own the outcome**        | You're asking for trust, not permission            |

## Common Traps

| Trap                            | Pattern                                   | Fix                                     |
| ------------------------------- | ----------------------------------------- | --------------------------------------- |
| **Risk theater**                | Long documents no one reads               | Identify top 3 risks, focus there       |
| **Optimism bias**               | "It'll probably be fine"                  | Pre-mortem: assume failure, explain why |
| **Pessimism paralysis**         | Every risk stops progress                 | Accept that progress requires some risk |
| **Diffusion of responsibility** | Everyone assumes someone else             | Name a single owner per risk            |
| **Hindsight judgment**          | Blaming past decisions with new info      | Judge decisions by process, not outcome |
| **Hero culture**                | Rewarding crisis response over prevention | Celebrate prevented incidents           |

## Questions to Ask

### Before Acting

- What's the worst that could happen?
- How likely is it?
- Can we recover if it happens?
- Who needs to know the risks?
- What's the cost of waiting?

### During Action

- Is this going as expected?
- What early signals would indicate failure?
- Are our mitigation plans working?
- Do we need to escalate?

### After Action

- What risks materialized?
- Did our estimates match reality?
- What would we do differently?
- What should we update in our risk models?

---

_"Take calculated risks. That is quite different from being rash."_ — George S.
Patton
