# Ecosystem

The ecosystem centers on Lore. Everything else reads from it, writes to it, or
advises about it.

## Orchestration Stack

Five projects compose the orchestration stack. Authority lives in
[lore/SYSTEM.md](https://github.com/your-org/lore/blob/main/SYSTEM.md).

| Project     | Role                                      | Status |
| ----------- | ----------------------------------------- | ------ |
| **Lore**    | Registry -- project topology, decisions   | Active |
| **Council** | Governance -- six-seat advisory framework | Active |
| **Praxis**  | Pragmatic synthesis layer over Lore       | Active |
| **Geordi**  | Unified API + GUIs for the ecosystem      | Active |
| **Forge**   | Spec, prototype, synthesize               | Active |

**The test:** Can you trace every project's primary dependency back to Lore? If
a project neither reads from nor writes to Lore, it belongs in CLI Tools or
Supporting Projects.

## The Loop

Nine components form a closed loop from intent to execution to validated record.

```text
┌─────────────────────────────────────────────────────────────────────┐
│                        Geordi (dashboard)                          │
│              Unified API + GUIs — the window into the loop         │
└──────────┬──────────────┬───────────────┬──────────────┬───────────┘
           │              │               │              │

                      Lore (durable record)
                   decisions, patterns, failures
                   intent, specs, project topology
                      │                 ▲
            feeds     │                 │  promotes
                      │                 │  (lore-scribe)
                      ▼                 │
          ┌───────────────────────┐     │
          │                       │     │
     SpecTrace              Council     │
     (what needs            (what       │
      verification)          matters)   │
          │                       │     │
          └───────┬───────────────┘     │
                  │                     │
                  ▼                     │
               Praxis                   │
            (synthesizes                │
             execution plan)            │
                  │                     │
                  ▼                     │
    ┌──────────────────────────┐        │
    │  Executor + Duet + Engram│        │
    │                          │        │
    │  Executor                │        │
    │  (Claude Code, OpenCode) │        │
    │       │          ▲       │        │
    │       │          │       │        │
    │       ▼          │       │        │
    │     Duet       Engram    │        │
    │  (skills)    (working    │        │
    │               memory)    │        │
    └──────┬──────────┬────────┘        │
           │          │                 │
           ▼          │                 │
        Entire        │                 │
     (session         │                 │
      capture)        │                 │
           │          │                 │
           ▼          │                 │
      SpecTrace       │                 │
     (validates)      │                 │
           │          │                 │
           └──────────┴─────────────────┘
          validated       temporal
          outcomes        insights
```

SpecTrace appears twice — as input (what needs work) and as gate (did the work
pass). Validation bookends execution.

### Components

| Component     | Role                  | Owns                                                 |
| ------------- | --------------------- | ---------------------------------------------------- |
| **Lore**      | Source of truth       | Decisions, patterns, failures, intent, topology      |
| **Council**   | Judgment              | Which decisions matter, which seat applies           |
| **SpecTrace** | Verification          | Spec → test → SLO traceability                       |
| **Praxis**    | Synthesis             | Composes Lore + SpecTrace + Council into plans       |
| **Executor**  | Execution (slot)      | Claude Code, OpenCode — the runtime, not a product   |
| **Duet**      | Human-agent interface | Skills that structure collaboration (/retro, /prose) |
| **Engram**    | Working memory        | Session context, observations, fast recall           |
| **Entire**    | Session capture       | Full transcripts, checkpoints, replay                |
| **Geordi**    | Dashboard             | Unified API + GUI across all components              |

### Data Flows

| Flow                         | What moves         | Why                                |
| ---------------------------- | ------------------ | ---------------------------------- |
| Lore → SpecTrace             | Specs, intent      | SpecTrace knows what to verify     |
| Lore → Council               | Decision history   | Council advises with full context  |
| SpecTrace + Council → Praxis | Gaps + judgment    | Praxis synthesizes what to do next |
| Praxis → Executor            | Execution plan     | Executor acts on synthesized plan  |
| Duet ↔ Executor              | Structured skills  | Human steers execution             |
| Engram ↔ Executor            | Working memory     | Fast recall mid-session            |
| Executor → Entire            | Session transcript | Entire captures the full flight    |
| Executor → SpecTrace         | Code changes       | SpecTrace validates against specs  |
| SpecTrace → Lore             | Validated outcomes | Verified results enter the record  |
| Engram → Lore                | Temporal insights  | Durable observations promote       |
| All → Geordi                 | Everything         | Geordi provides the unified view   |

### Memory Systems

| System     | Speed   | Durability        | Scope         | Trust level         |
| ---------- | ------- | ----------------- | ------------- | ------------------- |
| **Engram** | Instant | Expires naturally | Session       | Observations        |
| **Lore**   | Query   | Append-only       | Cross-project | Validated decisions |
| **Entire** | Replay  | Per-session       | Per-repo      | Full transcript     |

## CLI Tools

Tools that implement pieces of the stack. These live in `~/dev/cli/`.

## Archived Projects

| Project | Original Role              | Status   | Notes                                 |
| ------- | -------------------------- | -------- | ------------------------------------- |
| Mirror  | Judgment capture           | Archived | Claude Memory absorbed capture role   |
| Neo     | Team orchestration         | Archived | Contracts remain at `cli/neo/`        |
| Bach    | Stateless workers          | Archived | Theory without active use             |
| Flow    | Multi-phase orchestration  | Archived | Absorbed into Neo before archival     |
| Ralph   | Review/planning state loop | Archived | Superseded by Claude Code agent-teams |

## Contracts

### Live

| Contract             | Owner    | Parties    | Defines                      |
| -------------------- | -------- | ---------- | ---------------------------- |
| **LORE_CONTRACT.md** | **Lore** | Any - Lore | Read/write protocol for data |

LORE_CONTRACT opens Lore's write path to every project. Decisions go to the
journal. Patterns, failures, observations, and sessions each have defined write
formats. Integration stays optional -- projects work without Lore but lose
cross-session memory.

### Archived (Designed, Not Deployed)

| Contract              | Owner   | Location   | Defines                         |
| --------------------- | ------- | ---------- | ------------------------------- |
| SIGNAL_CONTRACT.md    | **Neo** | `cli/neo/` | State schema, signal vocabulary |
| TASK_CONTRACT.md      | **Neo** | `cli/neo/` | Task/result envelopes, workers  |
| CONTAINER_CONTRACT.md | **Neo** | `cli/neo/` | Sandboxed container access      |

Neo's orchestration model required these contracts. The files exist on disk but
no runtime consumes them.

## Common Traps

| Trap                   | Pattern                                                  | Fix                                       |
| ---------------------- | -------------------------------------------------------- | ----------------------------------------- |
| **Lore bypass**        | Project writes its own state instead of using Lore       | Route through LORE_CONTRACT               |
| **Missing reader**     | Writer exists, reader doesn't                            | Annotate: "who reads this and when"       |
| **Registry drift**     | Lore registry diverges from reality                      | `lore validate` catches it                |
| **Phantom dependency** | Project references another without contract              | Add the contract or remove the dependency |
| **Ghost names**        | Code references Lineage, Oracle, Flow, Ralph             | See [ghost-names.md](ghost-names.md)      |
| **Stale framing**      | Documentation describes architecture that no longer runs | Update the doc or mark it historical      |

## Questions to Ask

### When Adding a Project

- Does it read from or write to Lore?
- What contracts does it expose and consume?
- Does it duplicate something that already exists?
- Does it belong in the orchestration stack or CLI tools?

### When Drawing Boundaries

- Can you trace data flow through the diagram?
- Does every arrow have a contract or acknowledged informal dependency?
- Which projects have writers without readers?

### Periodically

- Does ecosystem.md match `~/dev/README.md`?
- Do any files still reference archived project names as active?
- Are informal dependencies growing toward needing contracts?

---

_Authority:
[lore/SYSTEM.md](https://github.com/your-org/lore/blob/main/SYSTEM.md)_
