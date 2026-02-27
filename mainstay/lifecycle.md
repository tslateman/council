# Lifecycle

> Examples reference Mirror and Neo (archived). The staged promotion pattern
> remains valid -- Claude Memory now handles capture, Lore handles storage.

Raw observations become formal knowledge through staged promotion.

## What a Lifecycle Is

| Lifecycle Is                                | Lifecycle Isn't                            |
| ------------------------------------------- | ------------------------------------------ |
| Phased progression from raw data to action  | A [loop](loop.md) repeating the same phase |
| Distinct semantics per phase (sync/promote) | Homogeneous iterations toward a signal     |
| Staging area between capture and commitment | Direct writes to the canonical store       |
| Human gates where judgment matters          | Fully autonomous end-to-end processing     |

**The test:** Does information change form as it moves through the system -- raw
to staged to formal to consumed? If yes, use a lifecycle. If the same operation
repeats until a condition clears, use a [loop](loop.md).

## Problem

Systems that capture observations and systems that act on knowledge evolve
independently. Without a named progression between them, raw data either
accumulates unreviewed or gets written directly into formal stores without
validation. The gap between "observed" and "trusted" stays invisible until bad
data reaches an agent session.

## Solution

Three explicit phases with a staging area between capture and commitment. Each
phase has a defined input, output, owner, and trigger. Promotion requires
validation -- garbage stays in the inbox until a human or policy promotes it.

## Anatomy

### The Three Phases

```text
Capture ──[sync]──> Staging ──[promote]──> Formal Store ──[execute]──> Session
```

Each arrow is a phase boundary. Data transforms at each crossing.

### Mechanics

| Phase       | Input                             | Output                             | Owner       | Trigger       |
| ----------- | --------------------------------- | ---------------------------------- | ----------- | ------------- |
| **Sync**    | `~/.mirror/*.md`                  | `lore/inbox/*.jsonl`               | Neo         | `neo sync`    |
| **Promote** | `lore/inbox/`                     | `lore/intent/` or `lore/patterns/` | Neo + Human | `neo promote` |
| **Execute** | `lore/intent/` + `lore/registry/` | Task envelope for Bach             | Neo         | `neo start`   |

**Sync** harvests raw observations into a staging area. No validation, no
filtering -- the inbox accumulates everything the capture system produces.

**Promote** converts staged observations into formal knowledge. This is the
quality gate. A human reviews, a policy filters, or both. Garbage that survives
sync dies here.

**Execute** hydrates agent context from the formal store and delegates work. By
this point, the promote phase has captured, validated, and committed the data.
The agent receives trusted knowledge, not raw observations.

### Phase Boundaries

| Boundary          | What Changes                           | What Stays               |
| ----------------- | -------------------------------------- | ------------------------ |
| Capture → Staging | Format (source-native → JSONL)         | Content fidelity         |
| Staging → Formal  | Status (raw → validated), location     | Semantic meaning         |
| Formal → Session  | Form (stored knowledge → task context) | Decision-relevant signal |

Each boundary is a contract. The upstream phase writes in the format the
downstream phase expects. No phase reaches past its neighbor.

### Feedback Loop Integration

The lifecycle is the structural backbone of the Feedback Loop initiative:

```text
Mirror (capture) → Lore inbox (staging) → Lore store (formal) → Sessions
```

Mirror captures. The [yeoman](yeoman.md) syncs. Lore stores. `lore resume`
injects. The lifecycle names what the initiative builds.

## Implementation

### Staging as Buffer

The inbox (`lore/inbox/`) is append-only JSONL. This matters:

- **Idempotent sync**: Re-running sync appends nothing if the marker file shows
  no new source data
- **Safe accumulation**: Bad data in the inbox costs nothing until promoted
- **Batch review**: A human can review ten observations at once rather than
  gatekeeping each one in real time

### Promotion Policies

Not all promotion requires a human. Policies can auto-promote based on
confidence, source, or category:

| Policy         | Promotes When                       | Example                           |
| -------------- | ----------------------------------- | --------------------------------- |
| **Manual**     | Human explicitly approves           | Architecture decisions            |
| **Confidence** | Source confidence exceeds threshold | Patterns validated 3+ times       |
| **Category**   | Source category matches allowlist   | Process observations auto-promote |
| **Time-gated** | Observation ages past threshold     | Promote after 7 days unreviewed   |

Start with manual. Add policies as the volume of observations justifies
automation.

### Layer Mapping

| Layer                   | Lifecycle Role         | Project |
| ----------------------- | ---------------------- | ------- |
| **Capture**             | Raw observation source | Mirror  |
| **Sync** (yeoman)       | Harvest into staging   | Neo     |
| **Staging** (inbox)     | Buffer for review      | Lore    |
| **Promote**             | Validate and commit    | Neo     |
| **Formal store**        | Trusted knowledge      | Lore    |
| **Execute** (injection) | Hydrate and delegate   | Neo     |

## Used In

| System            | Role                                                              |
| ----------------- | ----------------------------------------------------------------- |
| Feedback Loop     | Mirror → Lore → Sessions circuit follows sync/promote/execute     |
| Lore Intent → Neo | Mission handoff follows the same phased progression               |
| Pattern curation  | Raw patterns accumulate, get validated, then reach agent sessions |

The lifecycle pattern applies wherever information crosses a trust boundary. The
[pipeline](pipeline.md) governs how stages connect. The [worker](worker.md)
executes the terminal phase. The lifecycle governs how information matures.

## Common Traps

| Trap                            | Pattern                                          | Fix                                               |
| ------------------------------- | ------------------------------------------------ | ------------------------------------------------- |
| **Promoting without review**    | Auto-promoting everything defeats the gate       | Start manual; add policies only with evidence     |
| **Executing without hydration** | Agent starts with stale or empty context         | Execute phase reads formal store, never the inbox |
| **Inbox as archive**            | Staging area accumulates without review          | Set review cadence; alert on inbox growth         |
| **Skipping the inbox**          | Writing directly to formal store bypasses review | All external data enters through sync, not import |
| **Phase coupling**              | Promote logic embedded in the sync script        | Each phase is a separate invocation               |
| **Invisible promotion**         | No record of what the team promoted or rejected  | Log every promotion decision with rationale       |

## Questions to Ask

### When Designing

- What enters the staging area, and who reviews it before promotion?
- Which promotion policies apply, and are they explicit or assumed?
- Does the execute phase hydrate from the formal store or the inbox?
- What happens to observations that are never promoted?

### When Inheriting

- Where is the staging area, and how large has it grown?
- Are promotion decisions logged, or do observations silently appear in the
  formal store?
- Does the sync phase track what it has already processed?
- Has anyone bypassed the inbox with direct writes?

### Periodically

- Is the inbox growing faster than promotion reviews?
- Do promoted observations reach agent sessions and change behavior?
- Have any auto-promotion policies promoted garbage?
- Does the lifecycle still justify three phases, or has one become ceremonial?

---

_"The goal is to turn data into information, and information into insight."_ --
Carly Fiorina
