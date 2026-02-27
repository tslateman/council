# Flow SDK Migration

## Status

Accepted (Hold — run the cheap experiment first)

## Context

Flow orchestrates task execution across the agent stack. Today it consists of
six markdown command files (`/flow:init`, `/flow:plan`, `/flow:execute`, etc.)
that instruct Claude how to manage `state.json`. The agent is the runtime —
there is no code, no build step, no process.

The proposed convergence path assumes Flow becomes a TypeScript or Python
application using the Agent SDK. `structured_output` would enforce envelope
schemas, envelope construction would become testable functions, and template
injection would become programmatic string interpolation.

The driving problem: JSON extraction from prose fails unpredictably. Task and
result envelopes produced by prompt-driven Flow sometimes parse wrong. The
Flow-Bach bridge has zero test coverage.

### Forces

| Force                       | Direction           |
| --------------------------- | ------------------- |
| Envelope parsing fragility  | Toward SDK          |
| Zero testability            | Toward SDK          |
| Six files, zero deps        | Against SDK         |
| `/flow:execute` unbuilt     | Against SDK (today) |
| Bach stays markdown         | Against SDK         |
| `structured_output` exists  | Toward SDK          |
| "Inspect by reading" parity | Against SDK         |

## Options Evaluated

| Option                        | Verdict      | Rationale                                                                                                            |
| ----------------------------- | ------------ | -------------------------------------------------------------------------------------------------------------------- |
| **SDK rewrite**               | Rejected now | Replaces 6 files with an application. Disproportionate to the stated problem. Revisit if data justifies it.          |
| **Markdown first + validate** | **Adopted**  | Build `/flow:execute` as markdown. Add post-hoc envelope validation. Measure failure rate. Cheapest possible signal. |
| **Prompt tightening only**    | Deferred     | May close the gap alone. Test as part of the markdown experiment, not as a standalone bet.                           |
| **Hybrid validation**         | **Adopted**  | Thin validation step (bash/jq or single TypeScript function) checks envelopes against TASK_CONTRACT.md schema.       |

## Decision

Hold the SDK migration. Build `/flow:execute` as markdown first. Add post-hoc
envelope validation. Measure compliance across 20+ runs. Let the data decide
whether the data justifies the SDK path.

The validation layer stands regardless — even an SDK-based Flow benefits from
schema checks at the boundary.

### Kill Criteria for Revisiting

The SDK path reopens if:

- Measured envelope failure rate exceeds 15% after prompt optimization and
  post-hoc validation
- Claude Code's Task tool roadmap confirms `outputFormat` will never ship
- Phase coordination logic demonstrably requires programmatic control that
  prompts cannot express
- A reference SDK-based orchestrator exists and proves the pattern

## Consequences

### What We Gain

- Data on actual failure rates before committing to a rewrite
- A validation layer useful in either paradigm
- Preserved "everything is a prompt" coherence across Flow and Bach
- Zero new dependencies, build steps, or deployment surface

### What We Accept

- Envelope parsing remains prompt-dependent (mitigated by validation)
- Flow stays untestable in isolation (mitigated by measuring compliance)
- We defer the SDK convergence path, not abandon it
- If the failure rate is high, we've added weeks before reaching the same
  conclusion

### Trade-offs Named

| We Chose               | Over                               | Because                                                             |
| ---------------------- | ---------------------------------- | ------------------------------------------------------------------- |
| Cheap experiment first | Building the "right" thing         | One-way doors demand data, not conviction                           |
| Post-hoc validation    | Schema enforcement at construction | Validation works in either paradigm; rewrite works in one           |
| Paradigm coherence     | Type safety                        | Bach-Flow seam costs compound; type safety can come via other paths |
| Zero dependencies      | Testable functions                 | Dependency surface is a maintenance tax paid forever                |

## Council Input

| Seat      | Position                                                                                                                                                                                                    |
| --------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Critic    | Hold. Problem-to-solution ratio suspicious. The actual driver may be architectural preference, not envelope compliance. Cargo cult risk: adopting SDK because it exists, not because constraints demand it. |
| Marshal   | Hold. One-way door approached without cheap experiment. Probability of first-attempt success low. Cost of waiting near zero. `/flow:execute` unbuilt in either paradigm — build the cheap version first.    |
| Mainstay  | Not formally invoked. Structural concern noted: paradigm split (code Flow, markdown Bach) creates a permanent seam in the orchestration layer.                                                              |
| Wayfinder | Not formally invoked. The elegant path: measure before migrating. Spike with kill switch converts a one-way door to a two-way door.                                                                         |

## Pre-Mortem

Six months from now, the SDK migration failed. Most likely causes:

1. Nobody measured the markdown failure rate first — SDK chosen on vibes
2. Paradigm split between Flow (code) and Bach (markdown) snagged every change
   crossing the boundary
3. Agent SDK shipped breaking changes; Flow inherited dependency churn the
   markdown version would have been immune to
4. Envelope construction was the easy problem; phase coordination remained
   prompt-driven regardless of paradigm
