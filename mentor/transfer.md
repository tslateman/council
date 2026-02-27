# Transfer

Memory that never returns to active work is ceremony, not knowledge.

## What Transfer Is / Isn't

| Transfer Is                                     | Transfer Isn't                        |
| ----------------------------------------------- | ------------------------------------- |
| Closing feedback loops so past work compounds   | Archiving everything for completeness |
| Ensuring retrieval, not just recording          | Documentation for its own sake        |
| Making past decisions findable at point of need | Building systems nobody queries       |
| Injecting patterns where agents resume work     | Hoarding wisdom in a central vault    |
| Measuring whether knowledge arrives             | Measuring how much knowledge enters   |

**The test:** Can an agent starting a new session access relevant lessons from
past work without manual intervention? If not, the system records but does not
transfer.

## The Write-Only Trap

Most memory systems fail the same way. They accumulate data and never return it.

```text
Write → Store → [gap] → Sessions proceed without it
```

The compound cost is invisible in any single session. An agent that rediscovers
a lesson already captured loses minutes. Across fifty sessions, that loss
compounds into days of repeated work, repeated mistakes, and repeated debates
already settled.

**The pattern:** Someone builds a knowledge base. People write to it
enthusiastically. Nobody reads it. The base grows. The enthusiasm fades. The
system becomes a graveyard of good intentions.

**Why it persists:** Writing feels productive. Storage is cheap. Retrieval
requires integration work that nobody prioritizes because the cost of not
retrieving spreads across future sessions that haven't happened yet.

**The test:** When did this system last change a decision? If the answer is
"never" or "I don't know," the system is write-only.

## The Closed Loop

A transfer system has four links. Break any one and the loop is open.

```text
Write → Store → Retrieve → Apply
  |                          |
  +---- Feedback Loop -------+
```

| Link         | What Happens                                 | Failure Mode                        |
| ------------ | -------------------------------------------- | ----------------------------------- |
| **Write**    | Capture decisions, patterns, judgments       | Nothing enters the system           |
| **Store**    | Persist in a queryable format                | Data exists but nobody can find it  |
| **Retrieve** | Surface relevant items at point of need      | Data is findable but never surfaced |
| **Apply**    | Agent uses retrieved knowledge in a decision | Data surfaces but agents ignore it  |

**The discipline:** Audit each link independently. Most systems break at
Retrieve -- the data exists, the query interface exists, but nothing triggers
retrieval at the moment it would help.

### Write Without Retrieve

| System Pattern                       | Items Written | Items Retrieved | Effective Transfer |
| ------------------------------------ | ------------- | --------------- | ------------------ |
| Decision log nobody reads            | Many          | Zero            | Zero               |
| CLAUDE.md loaded every session       | Few           | Every session   | High               |
| Pattern store with session injection | Growing       | Per-session     | Compounds          |

Volume of writing is a vanity metric. Frequency of retrieval is the signal.

## Mechanisms

Three integration points close the loop at different depths.

### Session Handoff

When one session ends and another begins, context must bridge the gap.
`lore resume` runs at session start, returning open threads and recent
decisions. The agent begins where the previous session stopped, not from zero.

| Handoff Component | What It Carries                   | Integration Point |
| ----------------- | --------------------------------- | ----------------- |
| Open threads      | Unfinished work from last session | `lore resume`     |
| Recent decisions  | Choices made, rationale given     | `lore resume`     |
| Relevant patterns | Validated lessons from past work  | `lore resume`     |

### Pattern Injection

Patterns validated across sessions surface at project entry. The agent receives
not just "what happened last time" but "what we've learned across all sessions
in this domain."

Three levels, ordered by depth:

| Level | What Agents See                     | When                    |
| ----- | ----------------------------------- | ----------------------- |
| 1     | Pattern names and confidence scores | `lore resume`           |
| 2     | Pattern context and solution        | `lore resume --verbose` |
| 3     | Phase-routed patterns matching work | Runtime integration     |

Level 1 is the MVP. Each level adds specificity without requiring the previous
level to change.

### Context Enrichment

Static context (CLAUDE.md) loads every session. Triggered context (hooks, seat
injection) loads on specific events. Phase-routed context loads based on the
current work phase. The three tiers form a hierarchy:

| Tier          | Example                | Token Cost | When It Loads       |
| ------------- | ---------------------- | ---------- | ------------------- |
| **Static**    | CLAUDE.md              | 500-1000   | Every session       |
| **Triggered** | Hooks, seat advice     | 100-200    | On specific events  |
| **Routed**    | Phase-matched patterns | 300-500    | Based on work phase |

**The principle:** Push knowledge as close to the decision point as possible.
Static context is the floor, not the ceiling. Triggered and routed context
deliver the right knowledge at the right moment.

## The Yeoman as Operational Tool

The Mentor's mandate requires closing feedback loops. The
[Yeoman pattern](../mainstay/yeoman.md) is the operational mechanism.

A yeoman carries data between systems without transforming it. For transfer,
this means: observations captured in working memory arrive in Lore's store.
Patterns validated in Lore surface in sessions. The yeoman does not interpret or
enrich -- it delivers.

| Transfer Gap       | Yeoman          | Source        | Destination         |
| ------------------ | --------------- | ------------- | ------------------- |
| Capture to storage | Memory to Lore  | Claude Memory | `lore remember` CLI |
| Storage to session | Lore to session | Pattern store | `lore resume`       |

The Mentor owns the feedback loop. The Mainstay owns the
[yeoman pattern](../mainstay/yeoman.md). The division is deliberate: the pattern
is structural (Mainstay's domain), the purpose is wisdom transfer (Mentor's
domain).

## Measuring Transfer

Transfer metrics are lagging indicators. The system works when agents make
better decisions -- a signal that takes sessions to appear.

| Metric                                   | What It Shows                |
| ---------------------------------------- | ---------------------------- |
| Patterns surfaced per session            | Retrieval link is working    |
| Decisions informed by retrieved patterns | Apply link is working        |
| Repeated mistakes across sessions        | Loop is open somewhere       |
| Time from capture to first retrieval     | Latency of the feedback loop |
| Pattern confidence trending upward       | Validation is happening      |

**The test:** Are agents making different decisions because of what the system
surfaces? If the answer is "we don't know," nobody measures the Apply link.

## Common Traps

| Trap                        | Pattern                                           | Fix                                                     |
| --------------------------- | ------------------------------------------------- | ------------------------------------------------------- |
| **Write-only memory**       | System accumulates data nobody reads              | Measure retrieval frequency, not write volume           |
| **Knowledge hoarding**      | Wisdom lives in one system with no outbound path  | Build the yeoman; connect the endpoints                 |
| **Documentation graveyard** | Docs written, never updated, never read           | Docs earn their existence through retrieval             |
| **Ceremony over transfer**  | Process requires capture; nothing requires review | Close the loop: capture triggers surfacing              |
| **Volume over signal**      | Every decision recorded; no filtering on retrieve | Confidence scores separate noise from validated lessons |
| **Retrieval without apply** | Patterns surface; agents ignore them              | Measure decisions changed, not patterns shown           |

## Questions

### When Building

- Which link in Write to Store to Retrieve to Apply is weakest?
- Does retrieval happen at the moment of decision, or at session start?
- What is the latency from capture to first retrieval?
- Who reads what this system writes?

### When Inheriting

- Where does knowledge accumulate, and where does it surface?
- Is there a yeoman connecting the capture system to the storage system?
- Can an agent query past decisions, or only read what's injected?
- What is the confidence model for patterns?

### Periodically

- Are agents making different decisions because of surfaced patterns?
- Has the write-only trap reappeared in any system?
- Is the yeoman running, or has everyone forgotten manual invocation?
- Do teams validate low-confidence patterns, or do they just accumulate?

---

_"We do not learn from experience. We learn from reflecting on experience."_ --
John Dewey
