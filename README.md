# Council

Six seats. One authority. Advisory layer for navigating the unknown and building
what lasts.

See [charter.md](charter.md) for oaths, mandates, and productive tensions.

## The Six Seats

| Seat                      | Directive            | Content                                                                                                                                                                                                                                                              |
| ------------------------- | -------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [Critic](critic/)         | Discipline of Doubt  | [Critique](critic/critique.md), [Decisions](critic/decisions.md), [Disagreement](critic/disagreement.md), [Career](critic/career.md)                                                                                                                                 |
| [Mentor](mentor/)         | Continuity of Wisdom | [Succession](mentor/succession.md), [Transfer](mentor/transfer.md), [Sessions](mentor/sessions.md)                                                                                                                                                                   |
| [Wayfinder](wayfinder/)   | Logic of Discovery   | [Exploration](wayfinder/exploration.md)                                                                                                                                                                                                                              |
| [Marshal](marshal/)       | Security of Action   | [Risk](marshal/risk.md), [Operations](marshal/operations.md), [Security Architecture](marshal/security-architecture.md)                                                                                                                                              |
| [Mainstay](mainstay/)     | Structural Anchor    | [Architecture](mainstay/architecture.md), [Ecosystem](mainstay/ecosystem.md), [Lifecycle](mainstay/lifecycle.md), [Loop](mainstay/loop.md), [State](mainstay/state.md), [Worker](mainstay/worker.md), [Pipeline](mainstay/pipeline.md), [Yeoman](mainstay/yeoman.md) |
| [Ambassador](ambassador/) | Voice Beyond         | [Influence](ambassador/influence.md), [Visibility](ambassador/visibility.md)                                                                                                                                                                                         |

## Initiatives

| Initiative                                                              | Owner              | Status            |
| ----------------------------------------------------------------------- | ------------------ | ----------------- |
| [Entire Integration](initiatives/entire-integration.md)                 | Mainstay, Mentor   | Active            |
| [Agent Optimization](initiatives/agent-optimization.md)                 | Mainstay           | In progress       |
| [Orchestration](initiatives/orchestration.md)                           | Mainstay           | Contracts defined |
| [Agent Definitions](initiatives/agent-definitions.md)                   | Mainstay, Marshal  | Phase 1 complete  |
| [Documentation and Onboarding](initiatives/documentation-onboarding.md) | Mentor, Ambassador | Phase 2 complete  |

### Deferred

| Initiative                                                     | Owner               | Status   |
| -------------------------------------------------------------- | ------------------- | -------- |
| [Morpheus Proposal](initiatives/deferred/morpheus-proposal.md) | Wayfinder           | Proposal |
| [Fleet Management](initiatives/deferred/fleet-management.md)   | Wayfinder, Marshal  | Deferred |
| [Geordi Buildout](initiatives/deferred/geordi-buildout.md)     | Wayfinder, Mainstay | Deferred |
| [Container Capture](initiatives/deferred/container-capture.md) | Mainstay            | Deferred |

### Resolved

| Initiative                                                      | Owner            | Outcome          |
| --------------------------------------------------------------- | ---------------- | ---------------- |
| [Feedback Loop](initiatives/feedback-loop.md)                   | Mentor, Mainstay | Complete         |
| [Agent Credentials](initiatives/agent-credentials.md)           | Marshal          | Simplified       |
| [Ecosystem Architecture](initiatives/ecosystem-architecture.md) | Mainstay         | Migrated to Lore |

## How It Works

The council advises on cross-project decisions across the
[agent stack](initiatives/orchestration.md). Each seat owns a domain. Invoke a
seat when its question applies:

- **Critic**: "What are we refusing to see?"
- **Mentor**: "Who will carry this forward?"
- **Wayfinder**: "What's the elegant path through?"
- **Marshal**: "What's the risk, and am I ready?"
- **Mainstay**: "What holds this together?"
- **Ambassador**: "How does the world see us, and what do we need from it?"

Initiatives track cross-project work with an accountable seat. Seat directories
hold advisory content -- frameworks and cheat sheets.

## Architecture Decision Records

| ADR                                                                | Status        |
| ------------------------------------------------------------------ | ------------- |
| [Dev Directory Tooling](docs/adr/adr-001-dev-directory-tooling.md) | Accepted      |
| [Flow SDK Migration](docs/adr/adr-002-flow-sdk-migration.md)       | Accepted/Hold |
| [Curated Resume](docs/adr/adr-003-curated-resume.md)               | Accepted      |

## Tooling

- **Pre-commit**: prettier, markdownlint, vale, lychee (link checker)
- **Lore**: hooks record seat-level changes to Lore (see `hooks/pre-commit`)
- **Marshal hook**: Pre-tool-use safety check via `.claude/marshal-blocks`

`make status` tracks initiative acceptance criteria. `make links-external`
verifies cross-repo links. `make test` includes Marshal hook security tests.

### Key Commands

```bash
make test            # security + orchestration tests (includes marshal hook)
make check           # format + lint + prose + links
make setup           # install git hooks
make status          # initiative acceptance criteria progress
make links-external  # cross-repo link verification
```
