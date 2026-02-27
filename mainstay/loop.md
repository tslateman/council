# Loop

> Examples reference Neo and Bach (archived). The loop pattern remains valid --
> apply it to whatever orchestration layer replaces them.

Autonomy without awareness is just thrashing.

## What a Loop Is

| Loop Is                                | Loop Isn't                      |
| -------------------------------------- | ------------------------------- |
| Stateless process reading shared state | A scheduler managing work items |
| Iteration toward a completion signal   | A daemon running indefinitely   |
| Single agent cycling through phases    | Multiple agents coordinating    |
| Exit conditions checked every pass     | Unbounded retry logic           |

**The test:** Does the agent need to track "where am I in a multi-phase
process?" If yes, use a loop. If the job is "do one thing, hand off," team
protocols suffice.

## Problem

An autonomous agent needs to drive multi-phase work—plan, implement,
review—without human intervention at each transition. But hardcoding the phase
sequence makes it brittle, and letting the agent decide freely makes it
unpredictable.

## Solution

Separate the _iteration_ from the _state_. The loop reads external state each
pass, acts on what it finds, and writes results back. A signal field in the
state file tells the loop what phase to execute next. Completion markers and
exit conditions prevent infinite cycling.

## Anatomy

### The Core Cycle

```text
┌──→ Read state
│        │
│        ▼
│    Check exit conditions
│        │
│        ▼ (not done)
│    Execute current phase
│        │
│        ▼
│    Increment iteration counter
│        │
└────────┘
```

### Exit Conditions

| Condition         | Meaning                              | Exit Code |
| ----------------- | ------------------------------------ | --------- |
| Completion marker | Work finished successfully           | 0         |
| Max iterations    | Safety limit reached                 | 1         |
| Quit file         | External stop request (`.quit` file) | 0         |
| Stuck detection   | No progress across N iterations      | 1         |

**The discipline:** Every loop must have at least two exit paths—success and
safety. A loop with only a completion check is one bug away from running
forever.

### Signal Contract

The loop doesn't decide what to do—it reads a signal.

| Field            | Purpose                         | Example Values                        |
| ---------------- | ------------------------------- | ------------------------------------- |
| `signal.action`  | Phase to execute this iteration | `plan`, `execute-phase`, `review`     |
| `signal.target`  | What the phase operates on      | `"authentication module"`             |
| `signal.ready`   | Whether the phase can proceed   | `true`, `false`                       |
| `signal.blocked` | What's preventing progress      | `"waiting for dependency resolution"` |

Action vocabulary follows a lifecycle:

```text
init → plan → [research] → execute-phase → [review] → complete
```

The state holder may skip optional phases (bracketed). The state holder—not the
loop—decides the sequence.

### Stuck Detection

| Signal                                    | Indicates               |
| ----------------------------------------- | ----------------------- |
| Same git HEAD across 3+ iterations        | Agent producing no work |
| `signal.action` unchanged across N passes | State holder stalled    |
| `signal.blocked` present and not clearing | External dependency     |

**The fix:** Log the stuck state, exit with failure, surface the blockage for
human review. Retrying the same action hoping for different results is the
definition of thrashing.

## Implementation

### Reading State (Not Caching It)

The loop reads state fresh each iteration. Caching defeats the purpose—the state
file is the communication channel between the loop and the state holder.

```text
iteration_start:
    state = read(".flow/state.json")
    signal = state.signal
    if signal.action == "complete":
        exit(0)
    if signal.ready == false:
        log("blocked: " + signal.blocked)
        sleep(backoff)
        continue
    execute(signal.action, signal.target)
    iteration++
```

### Layer Separation

| Layer              | Owns                    | Reads               | Writes              |
| ------------------ | ----------------------- | ------------------- | ------------------- |
| **Loop**           | Iteration, exit checks  | `state.json`        | Work output (files) |
| **State** (Neo)    | Phase sequence, signals | Work output, events | `state.json`        |
| **Workers** (Bach) | Task execution          | Task envelopes      | Task results        |

**The test:** If the loop is writing to `state.json`, the layers tangle. The
loop produces work; the state holder interprets it and updates the signal.

## Used In

| Project | Role                                                        |
| ------- | ----------------------------------------------------------- |
| Neo     | State holder -- manages `state.json`, orchestrates phases   |
| Bach    | Stateless workers -- receive task envelopes, return results |

Neo holds state and orchestrates; Bach executes tasks.

## Common Traps

| Trap                  | Pattern                                     | Fix                                        |
| --------------------- | ------------------------------------------- | ------------------------------------------ |
| **Infinite optimist** | No max iteration limit                      | Always set a ceiling; fail loud at it      |
| **State hoarder**     | Loop caches state between iterations        | Read fresh every pass                      |
| **Phase creep**       | Loop decides which phase comes next         | State holder owns the sequence             |
| **Silent stuck**      | Loop iterates but produces nothing          | Detect same-HEAD runs, exit on threshold   |
| **Tangled layers**    | Loop writes state instead of producing work | Loop writes files; state holder reads them |
| **Missing quit**      | No external kill switch                     | Check for `.quit` file each iteration      |

## Questions to Ask

### When Designing

- What are the exit conditions, and are they sufficient?
- Who owns the phase sequence—the loop or the state holder?
- How will stuck detection work?
- What's the max iteration limit, and what happens when it's hit?

### When Inheriting

- Where does the loop read state from?
- What signal values does it act on?
- How does stuck detection trigger, and does it work?
- Is there a quit mechanism, and has anyone tested it?

### Periodically

- Are loops completing, or frequently hitting max iterations?
- Does stuck detection fire, and does anyone review the logs?
- Has the signal vocabulary grown beyond what the loop handles?

---

_"The purpose of abstraction is not to be vague, but to create a new semantic
level in which one can be absolutely precise."_ — Edsger Dijkstra
