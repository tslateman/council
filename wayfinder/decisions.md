# Decision Records

Exploration without a record is tourism. Decision records preserve the path
taken and the paths refused.

## What a Decision Record Is

| Decision Record Is                                | Decision Record Isn't                    |
| ------------------------------------------------- | ---------------------------------------- |
| Snapshot of forces, options, and trade-offs       | Meeting minutes or discussion log        |
| Explanation of why, not just what                 | Implementation plan or task list         |
| Record of dissent alongside the chosen path       | Consensus document that hides objections |
| Navigational aid for the next person at this fork | Justification written after the fact     |

**The test:** Can a newcomer read the record and understand why the team
rejected each option -- without asking the author? If not, the record is
incomplete.

## How Exploration Produces ADRs

Wayfinder's work follows a progression: explore, pathfind, decide, record.

```text
Exploration ──> Pathfinding ──> Council Deliberation ──> ADR
  (survey)       (evaluate)       (multi-seat input)     (record)
```

[Exploration](exploration.md) surveys the terrain and surfaces options.
[Pathfinding](pathfinding.md) scores options against forces and names
trade-offs. Council deliberation brings seat perspectives -- Critic challenges,
Marshal assesses risk, Mainstay checks structural fit. The ADR captures the
outcome.

Not every exploration produces an ADR. The threshold:

| Produced an ADR                         | Skipped the ADR                      |
| --------------------------------------- | ------------------------------------ |
| One-way door or trapdoor decision       | Two-way door with low switching cost |
| Multiple seats contributed input        | Single-seat or obvious path          |
| Trade-offs affect more than one project | Trade-offs stay local                |
| Future teams will face the same fork    | Unique situation, unlikely to recur  |

## ADR Structure

Council ADRs follow a consistent structure. Each section maps to a phase of
Wayfinder's process.

| Section               | Source Phase   | Purpose                               |
| --------------------- | -------------- | ------------------------------------- |
| **Context**           | Exploration    | Problem, forces, constraints          |
| **Options Evaluated** | Pathfinding    | Scored options with verdicts          |
| **Decision**          | Deliberation   | Chosen path with rationale            |
| **Consequences**      | Pathfinding    | Named trade-offs -- gains and accepts |
| **Council Input**     | Deliberation   | Per-seat positions and dissent        |
| **Pre-Mortem**        | Critic/Marshal | Future failure modes to watch for     |

## Architecture Decision Records

Decision records from council deliberations live in `docs/adr/`. Each records
the exploration, the options evaluated, the council input, and the trade-offs
accepted.

| ADR                                                     | Decision                                      | Key Trade-off                                       |
| ------------------------------------------------------- | --------------------------------------------- | --------------------------------------------------- |
| [ADR-001](../docs/adr/adr-001-dev-directory-tooling.md) | Adopt zoxide, skip ghq/gita/mani              | Flat layout discipline over structural organization |
| [ADR-002](../docs/adr/adr-002-flow-sdk-migration.md)    | Hold SDK migration; measure markdown first    | Cheap experiment over building the "right" thing    |
| [ADR-003](../docs/adr/adr-003-curated-resume.md)        | Wire FTS5 into resume; defer persistent score | Plumbing existing infra over new curation layer     |

### Patterns Across ADRs

Reading the records together reveals recurring decision patterns:

| Pattern                       | Seen In       | Principle                              |
| ----------------------------- | ------------- | -------------------------------------- |
| **Measure before migrating**  | ADR-002, -003 | Data beats conviction for one-way      |
|                               |               | doors                                  |
| **Wire before building**      | ADR-003       | Existing infrastructure often covers   |
|                               |               | the gap                                |
| **One registry, not two**     | ADR-001       | Parallel registries drift; choose one  |
| **Cheapest experiment first** | ADR-002       | The spike that disproves the migration |
|                               |               | saves months                           |

## Creating a New ADR

When pathfinding produces a one-way door decision with council input:

1. Number it sequentially: `adr-NNN-short-slug.md`
2. Place it in `docs/adr/`
3. Follow the structure above: Context, Options, Decision, Consequences, Council
   Input, Pre-Mortem
4. Record every seat that contributed, including dissent
5. Add the entry to the table in this file

**The discipline:** Write the ADR before implementing. The record captures the
reasoning while it's fresh. Post-hoc ADRs become justifications, not decisions.

## Common Traps

| Trap                         | Pattern                                | Fix                                          |
| ---------------------------- | -------------------------------------- | -------------------------------------------- |
| **Missing dissent**          | ADR shows agreement; objections lost   | Record every seat's position, especially     |
|                              |                                        | disagreement                                 |
| **Post-hoc rationalization** | ADR written after implementation       | Write ADR before implementing                |
| **ADR as approval**          | Record used to justify, not to decide  | The ADR captures the fork, not the sign-off  |
| **Orphaned ADR**             | Record exists but nobody finds it      | Cross-link from seat directory and CLAUDE.md |
| **Over-recording**           | Every small choice gets an ADR         | Reserve ADRs for one-way doors and           |
|                              |                                        | multi-seat deliberations                     |
| **Stale ADR**                | Decision reversed but record unchanged | Add "Superseded by ADR-NNN" to status        |

## Questions to Ask

### Before Writing

- Is this a one-way door? If two-way, does it still warrant a record?
- Did multiple seats contribute? If single-seat, is an ADR necessary?
- Will someone face this same fork in the future?

### While Writing

- Are the rejected options explained well enough for a newcomer?
- Is dissent recorded, or have I smoothed it into false consensus?
- Does the pre-mortem name concrete failure modes, not vague risks?

### After Writing

- Is the ADR linked from wayfinder/decisions.md?
- Can someone find it without knowing it exists?
- Does the decision still hold, or have conditions changed?

---

_"Those who cannot remember the past are condemned to repeat it."_ -- George
Santayana
