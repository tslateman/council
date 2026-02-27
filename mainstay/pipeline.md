# Pipeline

> Examples reference Neo and Bach (archived). The pipeline pattern remains valid
> -- apply it to whatever orchestration layer replaces them.

Each stage transforms; no stage reaches past its neighbor.

## What a Pipeline Is

| Pipeline Is                                      | Pipeline Isn't                          |
| ------------------------------------------------ | --------------------------------------- |
| Linear stages connected by narrow contracts      | A message bus with broadcast channels   |
| Adjacent-only coupling between components        | A mesh where everything talks freely    |
| Data transforming as it flows through each stage | A shared database with multiple readers |
| Independently evolvable stages                   | Tightly coupled modules in one deploy   |

**The test:** Can you replace one stage without touching any stage beyond its
immediate neighbors? If yes, the pipeline holds. If a stage change ripples three
hops away, you have a mesh disguised as a pipeline.

## Problem

Multiple components need to coordinate work, but connecting them freely creates
a mesh: every component depends on every other, changes cascade unpredictably,
and no one can draw the data flow on a whiteboard. Adding a new component means
touching N existing ones instead of one.

## Solution

Arrange components in a linear sequence where each stage receives input from the
stage before it and sends output to the stage after it. Define a narrow contract
at each boundary. Stages communicate only with their adjacent neighbors -- never
reaching past them to read or write state they don't own.

## Anatomy

### Stage Topology

A pipeline is a line, not a graph.

```text
Stage A ──[contract]──> Stage B ──[contract]──> Stage C
```

Each arrow is one contract governing the interface. Bidirectional flow (results
returning upstream) travels the same boundary:

```text
Harness ──[Signal Contract]──> Neo ──[Task Contract]──> Bach
                              Neo <──[Task Contract]──  Bach
```

Neo sends task envelopes to Bach; Bach returns result envelopes through the same
contract. The harness reads `state.json` through the Signal Contract; Neo writes
it. No component skips a stage.

### Contracts as Boundaries

Each boundary has one contract owned jointly by the two adjacent stages.

| Boundary        | Contract           | Upstream Sends | Downstream Returns |
| --------------- | ------------------ | -------------- | ------------------ |
| Harness <-> Neo | SIGNAL_CONTRACT.md | Signal reads   | State writes       |
| Neo <-> Bach    | TASK_CONTRACT.md   | Task envelopes | Result envelopes   |

The contract defines the data format, the vocabulary, and the expectations. It
says nothing about how either side implements its logic. Neo can rewrite its
state management without touching Bach. Bach can add worker types without
changing Neo.

### Data Transformation

Each stage transforms data, adding value as it passes through.

| Stage   | Receives         | Transforms To         | Passes Forward    |
| ------- | ---------------- | --------------------- | ----------------- |
| Harness | User request     | Signal action         | Reads state, acts |
| Neo     | Signal + results | State, task envelopes | Tasks to workers  |
| Bach    | Task envelope    | Executed work         | Result envelope   |

A user request enters the harness as intent. The harness reads Neo's state to
determine the next action. Neo decomposes phases into task envelopes. Bach
executes each task and returns structured results. At each stage, the data grows
more specific and more actionable.

### Adjacent-Only Visibility

| Component | Knows                          | Doesn't Know                   |
| --------- | ------------------------------ | ------------------------------ |
| Harness   | Signal Contract                | Task Contract, worker types    |
| Neo       | Signal Contract, Task Contract | How workers execute            |
| Bach      | Task Contract                  | Signal Contract, project state |

**The discipline:** The harness never sends task envelopes to Bach. Bach never
reads `state.json`. Each component sees only the contract at its boundary. If a
component needs information from two hops away, the intermediate stage must
transform and relay it.

## Implementation

### Contract Placement

Contracts live in the downstream project, adjacent to the code they govern.

| Contract           | Lives In    | Why                                       |
| ------------------ | ----------- | ----------------------------------------- |
| SIGNAL_CONTRACT.md | `cli/neo/`  | Neo owns the state format it writes       |
| TASK_CONTRACT.md   | `cli/bach/` | Bach owns the envelope format it consumes |

The downstream component owns the contract because it defines what it accepts.
The upstream component reads the contract to know what to send. Changes to the
contract start with the downstream owner.

### Pipeline Composition

Pipelines nest. The council pipeline (Harness -> Neo -> Bach) operates inside
the broader orchestration pipeline:

```text
Lore Intent ──> Neo ──> [Council pipeline: Harness -> Neo -> Bach]
```

Lore Intent decomposes goals into missions. Neo provisions teams. Within each
team session, the council pipeline handles state and execution. The outer
pipeline doesn't know about task envelopes; the inner pipeline doesn't know
about missions. Each pipeline maintains its own adjacent-only discipline.

The forge cluster follows the same topology:

```text
spec-trace ──> get-shit-done ──> coalesce
```

Specs define what to prototype. Parallel prototypes feed synthesis. Each stage
transforms and passes forward.

### Adding a Stage

To add a stage to a pipeline:

1. Define the new contract between the new stage and its neighbor
2. Implement the new stage, consuming the upstream contract
3. Update the downstream stage to consume the new stage's output
4. No other stages change

If adding a stage requires modifying stages beyond the immediate neighbors, the
pipeline has hidden coupling.

## Used In

| Pipeline      | Stages                        | Contracts                        |
| ------------- | ----------------------------- | -------------------------------- |
| Council       | Harness -> Neo -> Bach        | SIGNAL_CONTRACT, TASK_CONTRACT   |
| Orchestration | Lore Intent -> Neo -> Council | Goal YAML, registry, missions    |
| Forge         | spec-trace -> GSD -> coalesce | Specs -> prototypes -> synthesis |

The council pipeline is the most formalized, with two explicit markdown
contracts. The orchestration and forge pipelines follow the same topology but
rely more on conventions than formal contracts.

The [loop](loop.md) iterates the pipeline. The [state holder](state.md) manages
transitions between stages. [Workers](worker.md) execute the terminal stage.

## Common Traps

| Trap                       | Pattern                                          | Fix                                                      |
| -------------------------- | ------------------------------------------------ | -------------------------------------------------------- |
| **Skip-stage coupling**    | Component reads from two stages upstream         | Route through the adjacent stage; add fields to contract |
| **Contract creep**         | Contract accumulates fields no consumer reads    | Audit contracts; remove dead fields                      |
| **Phantom pipeline**       | Diagram shows a pipeline, code has direct calls  | Validate contracts match actual data flow                |
| **Shared state shortcut**  | Two stages share a database instead of contracts | Each stage owns its storage; contracts carry the data    |
| **Orchestrator overreach** | One stage controls all others directly           | Each stage knows only its neighbors                      |
| **Undocumented boundary**  | Stages communicate through implicit conventions  | Write the contract; implicit is a bug waiting            |

## Questions to Ask

### When Designing

- What data transforms at each stage, and does each transformation add value?
- Can you replace each stage independently without cascading changes?
- Does every boundary have an explicit contract, or are some implicit?
- Is the topology genuinely linear, or are there hidden cross-stage
  dependencies?

### When Inheriting

- Where do the contracts live, and which stage owns each one?
- Are all stages actually communicating through contracts, or have shortcuts
  appeared?
- Which pipelines use formal contracts (markdown) vs. convention (implicit)?
- Has the pipeline grown stages you could collapse?

### Periodically

- Are contracts still minimal, or have they accumulated unused fields?
- Do stages still respect adjacent-only visibility, or have shortcuts crept in?
- Has composition stayed clean, or do inner pipelines leak into outer ones?
- Are new integrations following the pipeline topology, or creating a mesh?

---

_"Perfection is achieved not when there is nothing more to add, but when there
is nothing left to take away."_ -- Antoine de Saint-Exupery
