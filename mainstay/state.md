# State

> Examples reference Neo (archived). The state management pattern remains valid
> -- apply it to whatever orchestration layer replaces it.

The one who holds state holds the conversation.

## What State Is

| State Is                               | State Isn't               |
| -------------------------------------- | ------------------------- |
| Single source of truth for work status | A log of what happened    |
| Communication channel between layers   | A database for querying   |
| Signal emitter for the next action     | Configuration or settings |
| Current position in a plan             | Cache of computed results |

**The test:** If two components disagree about what's happening, whichever reads
the state file wins. That's what makes it the source of truth.

## Problem

An autonomous loop drives multi-phase work, but it can't track progress itself —
that would tangle iteration with sequencing. Workers execute tasks, but they
can't see the bigger picture. Something needs to hold the plan, track progress,
and signal what comes next — without executing any of the work itself.

## Solution

A centralized state file that the loop reads and the workers ignore. One
component — the state holder — owns this file exclusively. It decomposes goals
into milestones, phases, and tasks, tracks completion, and emits signals that
tell the loop what to do next. The state holder manages; it never implements.

## Anatomy

### The State File

```text
.flow/
├── state.json    # Machine state: milestones, phases, tasks, signals
├── PLAN.md       # Human-readable plan (mirrors state.json)
└── research/     # Investigation findings from research phases
```

**Gitignored.** State is runtime, not source. Git provides the history.

### Schema

| Field              | Type         | Purpose                                             |
| ------------------ | ------------ | --------------------------------------------------- |
| `goal`             | string       | What you're building (one sentence)                 |
| `scope.in`         | string[]     | What's included                                     |
| `scope.out`        | string[]     | What's excluded                                     |
| `constraints`      | string[]     | Technical, deadline, requirement                    |
| `successCriteria`  | string       | How you know when it's done                         |
| `status`           | enum         | planning, researching, executing, blocked, complete |
| `currentMilestone` | string\|null | Active milestone ID                                 |
| `currentPhase`     | string\|null | Active phase ID                                     |
| `milestones[]`     | object[]     | Ordered deliverables                                |
| `signal`           | object       | Next action for the loop                            |

### Milestone → Phase → Task Hierarchy

| Level         | Granularity             | Status Values                            |
| ------------- | ----------------------- | ---------------------------------------- |
| **Milestone** | Shippable increment     | pending, completed                       |
| **Phase**     | Coherent group of tasks | pending, in-progress, completed          |
| **Task**      | Single unit of work     | pending, in-progress, completed, blocked |

Each task carries `dependencies` (other task IDs), `acceptanceCriteria`, and
`estimatedEffort` (small/medium/large). The state holder uses these to determine
readiness and ordering.

### Signal Contract

The signal is the state holder's instruction to the loop. See [loop.md](loop.md)
for how the loop reads it.

| Field            | Purpose                        | Example Values                    |
| ---------------- | ------------------------------ | --------------------------------- |
| `signal.action`  | What the loop should do next   | `plan`, `execute-phase`, `review` |
| `signal.target`  | What the action operates on    | `"3"` (phase ID)                  |
| `signal.ready`   | Whether the action can proceed | `true`, `false`                   |
| `signal.blocked` | What's preventing progress     | `"waiting for API key"`           |

**The discipline:** After every command, the state holder must update all four
signal fields. A stale signal is a lie — the loop will act on it.

### Signal Lifecycle

```text
init → plan → [research] → execute-phase → [review] → complete
                  ↑              │
                  └──────────────┘
                   (if unknowns)
```

| Transition                    | Trigger                      | State Holder Writes                                   |
| ----------------------------- | ---------------------------- | ----------------------------------------------------- |
| init → plan                   | Goal and scope captured      | `action: "plan"`, `ready: true`                       |
| plan → research               | Unknowns identified          | `action: "research"`, `ready: true`                   |
| plan → execute-phase          | No unknowns, phases ready    | `action: "execute-phase"`, `target: "1"`              |
| execute-phase → review        | Phase tasks all completed    | `action: "review"`, `target: "1"`                     |
| execute-phase → execute-phase | Review passed, next phase    | `action: "execute-phase"`, `target: "2"`              |
| any → blocked                 | Dependency unresolvable      | `action: "none"`, `ready: false`, `blocked: "reason"` |
| execute-phase → complete      | All phases done, audit clean | `action: "complete"`, `ready: true`                   |

Bracketed phases (research, review) are optional. The state holder decides
whether to include them based on the plan.

## Implementation

### Who Writes State

Only the state holder writes `state.json`. In the current stack, that's Neo.

| Command         | What It Writes                           |
| --------------- | ---------------------------------------- |
| `/neo:init`     | Goal, scope, constraints, initial signal |
| `/neo:plan`     | Milestones, phases, tasks, `PLAN.md`     |
| `/neo:research` | Research findings, updated signal        |
| `/neo:execute`  | Task status, phase progress, next signal |
| `/neo:review`   | Validation results, phase completion     |
| `/neo:status`   | **Nothing** -- read-only command         |

**The test:** If a command doesn't update the signal after modifying state, the
loop will act on stale information. Every write must end with a fresh signal.

### Dual Representation

State has two faces:

| Representation | Audience | Format                    | Updated By   |
| -------------- | -------- | ------------------------- | ------------ |
| `state.json`   | Machines | Structured JSON           | Neo commands |
| `PLAN.md`      | Humans   | GSD-style readable markup | Neo commands |

Both represent the same plan. `state.json` is the source of truth; the system
regenerates `PLAN.md` from it. When they disagree, `state.json` wins.

### Agent-Driven Execution

Neo is a Claude Code plugin. The agent writes state via the Write tool -- there
is no daemon, no server, no process. Commands are markdown files that instruct
the agent what to read, decide, and write.

This means:

- State updates are atomic (single file write)
- No concurrency conflicts (one agent, one loop)
- No process to crash or restart
- State is inspectable at any point (it's a JSON file)

### Delegation to Workers

The state holder delegates tasks but never executes them.

| Step | State Holder Does                          | Worker Does             |
| ---- | ------------------------------------------ | ----------------------- |
| 1    | Builds task envelope (id, worker, context) | —                       |
| 2    | Spawns worker via Task tool                | Receives envelope       |
| 3    | —                                          | Executes task           |
| 4    | —                                          | Returns result envelope |
| 5    | Updates task status and signal             | —                       |

**The boundary:** The worker doesn't know about state.json, milestones, or other
tasks. It knows its envelope. The state holder doesn't know how the worker
executes. It knows the result.

### Layer Visibility

| Component | Knows              | Doesn't Know              |
| --------- | ------------------ | ------------------------- |
| Loop      | Signal contract    | Bach exists, task details |
| Neo       | Both contracts     | How workers execute       |
| Bach      | Task contract only | Project state, plan       |

## Used In

| Project | Role                                                        |
| ------- | ----------------------------------------------------------- |
| Neo     | State holder -- owns `state.json`, emits signals, delegates |
| Bach    | Workers -- execute task envelopes, return results           |

## Common Traps

| Trap                          | Pattern                                           | Fix                                         |
| ----------------------------- | ------------------------------------------------- | ------------------------------------------- |
| **Stale signal**              | State updated but signal not refreshed            | Every write must end with signal update     |
| **State as log**              | Appending history instead of current position     | State is present tense; git is past tense   |
| **Split brain**               | `PLAN.md` and `state.json` diverge                | Regenerate PLAN.md from state.json          |
| **Worker peeking**            | Worker reads state.json for context               | Pass context in the task envelope           |
| **Loop writing state**        | Loop updates status directly                      | Loop produces work; state holder interprets |
| **Orchestrator implementing** | State holder executes tasks instead of delegating | Manage and verify, never implement          |

## Questions to Ask

### When Designing

- What fields does the loop need from state, and only those?
- Is every signal transition accounted for, including error paths?
- Can someone understand the state file by reading it cold?
- Where does state live, and who cleans it up?

### When Inheriting

- Which component writes state, and is it truly exclusive?
- Are PLAN.md and state.json generated from the same source?
- What happens when a task blocks — does the signal reflect it?
- Is the signal vocabulary documented, or discovered by reading code?

### Periodically

- Are signals going stale (state changes without signal updates)?
- Is state accumulating fields that nothing reads?
- Are workers staying ignorant of state, or have shortcuts crept in?
- Does the dual representation still track, or has drift begun?

---

_"State is easy to build but hard to debug when wrong, and so the ideal is to
have none."_ — Rich Hickey (paraphrased)
