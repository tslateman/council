# Worker

A specialist earns trust by knowing what it can't do.

## What a Worker Is

| Worker Is                             | Worker Isn't                    |
| ------------------------------------- | ------------------------------- |
| Stateless specialist receiving a task | A daemon running continuously   |
| Scoped executor returning a result    | An orchestrator choosing work   |
| Honest about incapability             | A black box hiding failures     |
| Interchangeable within its specialty  | A singleton owning shared state |

**The test:** Does the component receive a self-contained envelope, execute
within a bounded specialty, and return a structured result? If yes, it's a
worker. If it decides what to do next or reads project state, it's an
orchestrator wearing a worker's hat.

## Problem

An orchestrator can decompose work into subtasks, but executing them itself
tangles planning with implementation. The orchestrator starts making coding
decisions, loses track of the plan, and can't evaluate its own output.
Delegation needs a formal boundary: a contract that defines what goes in, what
comes back, and what the worker may touch.

## Solution

Stateless specialists receiving task envelopes and returning result envelopes.
Each worker knows its specialty and nothing else. The manager builds envelopes
from project context, dispatches them to the right worker type, and interprets
the results. Workers never see the plan, the state file, or other tasks in the
phase.

## Anatomy

### Manager/Worker Split

```text
User Request
     |
+-----------------------------------------------+
|                    MANAGER                     |
|  * Analyze objectives                          |
|  * Decompose into subtasks                     |
|  * Delegate to workers                         |
|  * Synthesize results                          |
|  * Never does the work                         |
+-----------------------------------------------+
       |                |                |
+-------------+  +-------------+  +-------------+
|  RESEARCHER |  |    CODER    |  |   REVIEWER  |
| Investigate |  |  Implement  |  |   Evaluate  |
|  Recommend  |  |    Test     |  |   Approve   |
+-------------+  +-------------+  +-------------+
       |                |                |
       +----------------+----------------+
                        |
                 Final Result
```

**The discipline:** The manager plans, delegates, and synthesizes. The worker
executes and reports. If the manager starts implementing, the separation breaks.
If the worker starts planning, it's scope-creeping.

### Task Envelope

The manager sends a task envelope -- everything the worker needs, nothing more.

```json
{
  "id": "2.1",
  "worker": "coder",
  "task": "Implement POST /auth/login endpoint",
  "context": {
    "acceptanceCriteria": "Returns JWT on valid credentials, 401 on invalid",
    "dependencies": ["Research recommended bcrypt for password hashing"],
    "constraints": ["Use existing Express setup", "PostgreSQL for storage"],
    "files": ["src/routes/auth.ts", "src/models/user.ts"]
  }
}
```

| Field                        | Type      | Purpose                           |
| ---------------------------- | --------- | --------------------------------- |
| `id`                         | string    | Task ID for the manager to track  |
| `worker`                     | string    | Worker type to invoke             |
| `task`                       | string    | What to do (imperative, specific) |
| `context.acceptanceCriteria` | string    | How the manager will judge done   |
| `context.dependencies`       | string[]  | Outputs from prior tasks          |
| `context.constraints`        | string[]  | Boundaries from project scope     |
| `context.files`              | string[]? | Relevant files to read or modify  |

### Result Envelope

The worker returns a result envelope -- structured so the manager can act on it
without reading the worker's mind.

**On success:**

```json
{
  "id": "2.1",
  "status": "complete",
  "summary": "Implemented login endpoint with bcrypt password verification",
  "artifacts": ["src/routes/auth.ts", "src/routes/auth.test.ts"],
  "notes": "Added rate limiting middleware as defensive measure"
}
```

**On failure:**

```json
{
  "id": "2.1",
  "status": "incapable",
  "reason": "Task requires database schema changes outside my scope",
  "suggestion": "Spawn a coder task first to add password_hash column"
}
```

| Field        | Type      | Purpose                            |
| ------------ | --------- | ---------------------------------- |
| `id`         | string    | Task ID (echoed back)              |
| `status`     | string    | `complete`, `incapable`, `blocked` |
| `summary`    | string    | What the worker did (past tense)   |
| `artifacts`  | string[]? | Files created or modified          |
| `notes`      | string?   | Observations for the manager       |
| `reason`     | string?   | Why incapable or blocked           |
| `suggestion` | string?   | How to unblock                     |

### Worker Specializations

| Worker       | Template                         | Specialty                             |
| ------------ | -------------------------------- | ------------------------------------- |
| `researcher` | `./workers/researcher-prompt.md` | Investigate, analyze, recommend       |
| `coder`      | `./workers/coder-prompt.md`      | Implement, test, debug                |
| `reviewer`   | `./workers/reviewer-prompt.md`   | Evaluate, find issues, approve/reject |
| `tester`     | `./workers/tester-prompt.md`     | Write tests, find edge cases          |

Each template defines scope boundaries: what the worker handles and what it
refuses. A coder implements but does not make architecture decisions. A reviewer
evaluates but does not fix what it finds. The boundaries prevent scope creep and
keep each worker's output predictable.

## Implementation

### Template Injection

The manager builds a complete prompt by injecting the task envelope into the
worker's template at a known insertion point.

```markdown
# Coder Worker

You are a Coder specialist. You implement, test, and debug.

## Task Envelope

{envelope as YAML or JSON}

## Your Scope

**You handle:** Writing code, writing tests, fixing bugs **You do NOT handle:**
Architecture decisions, research, deployment

## Output Format

Return a JSON result envelope: ...
```

The template carries the worker's identity, scope boundaries, and output format.
The envelope carries the specific task. Neither knows about the other until
injection time.

### Incapability Signaling

A worker that fails silently wastes more time than one that never started. The
`incapable` status is the honest path.

| Status      | Meaning                            | Manager's Response              |
| ----------- | ---------------------------------- | ------------------------------- |
| `complete`  | Task done, criteria met            | Mark task complete, continue    |
| `incapable` | Wrong worker or missing dependency | Reassign or add a blocking task |
| `blocked`   | External blocker                   | Record blocker, try other tasks |
| `partial`   | Some progress, needs continuation  | Record progress, re-queue       |

**The discipline:** Workers must signal `incapable` when the task falls outside
their scope, rather than producing low-quality work. An honest "I can't" is more
valuable than a confident wrong answer.

### Layer Visibility

| Component   | Knows                   | Doesn't Know                  |
| ----------- | ----------------------- | ----------------------------- |
| **Manager** | Worker types exist      | How workers execute           |
|             | Envelope format         | Internal worker prompts       |
|             | Result format           | Worker decision-making        |
| **Worker**  | Envelope it received    | Other tasks in the phase      |
|             | Its specialty           | Project state                 |
|             | How to signal incapable | What happens after it returns |

**The test:** If a worker reads `state.json` or checks what other workers
produced, the layers tangle. Workers know their envelope and their specialty.
The manager knows the plan and the results.

## Used In

| Project | Role                                                     |
| ------- | -------------------------------------------------------- |
| Council | Worker agents -- 23 specialized agents serving six seats |
| Lore    | Yeoman workers -- data bridges between systems           |

The worker pattern completes the council stack: the [loop](loop.md) iterates,
the [state holder](state.md) sequences, and workers execute.

## Common Traps

| Trap                     | Pattern                                      | Fix                                                |
| ------------------------ | -------------------------------------------- | -------------------------------------------------- |
| **Scope creep**          | Worker makes decisions outside its specialty | Template defines explicit scope boundaries         |
| **Silent failure**       | Worker returns vague "done" on partial work  | Require structured result with acceptance check    |
| **State peeking**        | Worker reads project state for context       | Pass all context in the envelope                   |
| **Manager implementing** | Manager writes code instead of delegating    | Manager plans, delegates, verifies -- never builds |
| **Missing incapable**    | Worker attempts tasks beyond its capability  | Train the honest "I can't" path                    |
| **Template bloat**       | Worker prompt accumulates unrelated concerns | One specialty per template; split when needed      |

## Questions to Ask

### When Designing

- What specialties does the system need, and are they cleanly separable?
- Does the envelope carry enough context for the worker to succeed
  independently?
- What happens when a worker signals `incapable` -- does the manager have a
  fallback?
- Are scope boundaries explicit in each template?

### When Inheriting

- Which worker templates exist, and what scope does each claim?
- How does the manager select which worker handles a task?
- Is the result envelope schema enforced or advisory?
- Do workers stay ignorant of project state, or have shortcuts crept in?

### Periodically

- Are workers signaling `incapable` appropriately, or silently producing bad
  output?
- Has template bloat eroded the specialty boundaries?
- Do envelopes carry the right context, or are workers guessing?
- Is the manager synthesizing results, or just collecting them?

---

_"The best executive is the one who has sense enough to pick good men to do what
he wants done, and self-restraint enough to keep from meddling with them while
they do it."_ -- Theodore Roosevelt
