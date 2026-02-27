# Documentation

Good docs disappear -- the reader finds what they need and moves on.

## What Documentation Is

| Documentation Is                         | Documentation Isn't                |
| ---------------------------------------- | ---------------------------------- |
| Entry points tuned to specific audiences | A single file covering everything  |
| Current state, not historical narrative  | A changelog or project diary       |
| Structured so agents parse it cold       | Prose that rewards careful reading |
| Maintained alongside the code it covers  | Written once and never updated     |

**The test:** Can an agent (human or automated) enter the project cold, read one
file, and know what to do next? If they need to read three files before finding
the starting point, the docs have failed.

## Problem

A project accumulates knowledge -- architecture, conventions, handoff notes,
onboarding steps -- but scatters it across READMEs, inline comments, wikis, and
tribal memory. New contributors (human or agent) waste their first hour
orienting instead of working. Worse, stale docs teach the wrong thing.

## Solution

Four documents, each for a distinct audience and purpose. CLAUDE.md orients the
agent. README.md orients the human. SYSTEM.md maps the architecture. HANDOFF.md
carries continuity. Each stays in its lane. Prose follows Strunk's discipline:
active voice, positive form, no needless words.

## Anatomy

### The Four Documents

```text
project/
  CLAUDE.md     Agent entry point (read first by every agent)
  README.md     Human entry point (quick start, prerequisites)
  SYSTEM.md     Architecture map (components, data flow, contracts)
  context/
    HANDOFF.md  Continuity log (newest first, cross-project notes)
```

Not every project needs all four. Small utilities need only CLAUDE.md and
README.md. SYSTEM.md appears when the project has multiple components or
cross-project interfaces. HANDOFF.md appears when work spans sessions or agents.

### CLAUDE.md -- Agent Entry Point

The first file every agent reads. Agents arrive cold: no prior context, no
browsing history, no memory of last session. CLAUDE.md must bootstrap them.

**Anatomy (in order):**

| Section               | Purpose                                 | Example                                      |
| --------------------- | --------------------------------------- | -------------------------------------------- |
| Title + one-liner     | What this project is                    | `# Lore` / `Memory that compounds.`          |
| Quick Navigation      | Jump table for common needs             | `Find a project -> mani.yaml`                |
| Architecture overview | How this project's parts relate         | Diagram or short prose                       |
| Commands              | What the agent can run                  | `./lore.sh resume`, `make test`              |
| Coding conventions    | Rules the agent must follow             | `set -euo pipefail`, `cargo fmt`             |
| Your Role Here        | What this project does and does not do  | `Lore does NOT execute work.`                |
| Before Making Changes | Pre-flight checklist                    | `Read SYSTEM.md`, `Check relationships.yaml` |
| Cross-Project         | Conventions shared across the ecosystem | `Conventional commits`, `Never use emdashes` |

**Key principles:**

- Lead with navigation, not narrative. Agents need "where is X" before "why X
  exists."
- Commands go early. An agent that can run tests and build knows enough to start
  working.
- "Your Role Here" prevents scope creep. Stating what a project does not do is
  as important as stating what it does.
- End with cross-project conventions so the agent follows ecosystem rules, not
  just local ones.

### README.md -- Human Entry Point

For the developer who clones the repo and wants to run it. Assumes a human
reader with a terminal open.

**Anatomy (in order):**

| Section       | Purpose                              | Example                                        |
| ------------- | ------------------------------------ | ---------------------------------------------- |
| Title + desc  | What this is, in one sentence        | `# Lore -- Memory, registry, intent`           |
| Quick Start   | Clone, install, run -- three steps   | `cargo build && cargo test`                    |
| Prerequisites | What to install beforehand           | `Go yq v4.52+, jq v1.7+, mani`                 |
| Structure     | Directory layout with annotations    | Tree listing with one-line glosses             |
| Key Concepts  | Core abstractions and their relation | Brief prose or a table                         |
| Testing       | How to run tests and what they cover | `make test`, `cargo test`                      |
| Part of Lore  | Cluster membership and contracts     | `Cluster: council, Contract: TASK_CONTRACT.md` |

**Key principles:**

- Quick Start goes above the fold. A developer who can't run the project in 60
  seconds will lose momentum.
- Prerequisites list exact versions. "Requires yq" means nothing; "Requires Go
  yq v4.52+" prevents a 30-minute debugging session against python-yq.
- Structure uses a flat list or tree, not prose. Developers scan; they don't
  read paragraphs about directory layout.

### SYSTEM.md -- Architecture Map

The index, not the authority. SYSTEM.md maps how components connect and where
contracts live. It does not duplicate what the contracts themselves define.

**Anatomy (in order):**

| Section       | Purpose                             | Example                                    |
| ------------- | ----------------------------------- | ------------------------------------------ |
| Overview      | System-level picture in one diagram | ASCII art showing all components           |
| Ecosystem Map | All projects, clusters, data flows  | Larger diagram with annotations            |
| Contracts     | Where interface specs live          | Table of contract names, owners, locations |
| Known Gaps    | Honest about what's missing         | Numbered list of unresolved items          |

**Key principles:**

- ASCII over Mermaid. Mermaid requires a parser; ASCII renders in any terminal,
  any editor, any diff viewer.
- Diagrams show relationships, not implementation. A box labeled "Flow (state)"
  tells you Flow's role. The box does not explain how Flow manages state --
  that's Flow's CLAUDE.md or the state pattern doc.
- The Contracts section points to contracts; it does not restate them. Dual
  representation drifts. One source of truth per fact.
- Known Gaps build trust. A system doc that claims completeness is lying.

### HANDOFF.md -- Continuity Log

Bridges the gap between sessions and between agents. Newest entries first so the
next agent sees the latest state immediately.

**Anatomy:**

| Element           | Purpose                            | Example                                      |
| ----------------- | ---------------------------------- | -------------------------------------------- |
| Datestamp heading | Handoff date                       | `### 2026-02-13: Pattern Docs, Site Cleanup` |
| Summary paragraph | What happened this session         | `Four patterns written at council/mainstay/` |
| Changes list      | Repos touched, commits referenced  | `flow: SIGNAL_CONTRACT.md updated (23742b3)` |
| Decisions         | Choices made and rationale         | `ASCII over Mermaid -- renders everywhere`   |
| Follow-up         | What the next agent should pick up | `Phase 4 remaining: docs, config patterns`   |

**Key principles:**

- Newest first. The next agent reads from the top and stops when context is
  sufficient. Old entries scroll off naturally.
- Reference commits by hash, not by description. "Updated Flow" is useless six
  sessions later; `23742b3` is permanent.
- Follow-up items are imperatives, not observations. "Write config pattern"
  gives the next agent a task. "Config pattern is still needed" gives them a
  fact they can't act on directly.

## Implementation

### Writing Style

All prose follows Strunk's Elements of Style:

| Rule                | Apply                                    | Avoid                                               |
| ------------------- | ---------------------------------------- | --------------------------------------------------- |
| Active voice        | "Flow manages state"                     | "State gets managed by Flow"                        |
| Positive form       | "The stack sits inside Lore"             | "The stack doesn't sit on top of Lore"              |
| Omit needless words | "This project tracks metadata"           | "This project is responsible for tracking metadata" |
| Definite, specific  | "Go yq v4.52+ at `/opt/homebrew/bin/yq`" | "Requires a YAML parser"                            |

**The discipline:** Every sentence earns its place. If removing a sentence
doesn't change what the reader does, remove it.

### Punctuation and Formatting

| Convention      | Rule                                                             | Example                        |
| --------------- | ---------------------------------------------------------------- | ------------------------------ |
| Dashes          | Double hyphen (`--`), never emdash (the single long dash)        | `Flow -- state holder`         |
| Code references | Backticks for files, commands, fields                            | `state.json`, `make test`      |
| Tables          | For structured comparisons; run `prettier --write` after editing | Is/Isn't tables, schema fields |
| Headings        | `##` for sections, `###` for subsections                         | `## Anatomy`, `### CLAUDE.md`  |
| Lists           | Bullets for unordered, numbers for sequences                     | Prerequisites vs. Quick Start  |

### Template Usage

The CLAUDE.md template (`patterns/templates/claude-md.md`) provides a starting
skeleton. Adapt it to the project:

- **Small utility**: Title, Quick Start, Structure, Conventions, Part of Lore.
  Skip architecture and navigation.
- **Clustered project**: Add cluster membership, adjacent interfaces, and
  cross-project conventions.
- **System hub** (Lore): Full template with Quick Navigation, role statement,
  and update triggers.

The template is a floor, not a ceiling. Add sections the project needs. Remove
sections it outgrows.

### Cross-Project Consistency

Every CLAUDE.md in the ecosystem shares these conventions:

- Conventional commits: `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`
- No emdashes in any documentation
- `Part of Lore` section pointing to the Lore project with cluster and contract
  info
- Coding conventions section (language-specific formatting and linting rules)

Lore's `metadata.yaml` tracks which projects have which contracts. The CLAUDE.md
in each project names those contracts so agents entering the project know the
interfaces they must respect.

## Used In

| Project | Documents                                   |
| ------- | ------------------------------------------- |
| Lore    | CLAUDE.md, README.md, SYSTEM.md, HANDOFF.md |
| Council | CLAUDE.md, README.md, CONTRIBUTING.md       |
| Praxis  | CLAUDE.md                                   |
| Geordi  | CLAUDE.md                                   |

Every project has CLAUDE.md. Only system-level projects carry all four
documents. Contracts are not docs -- they are interfaces governed by the
[pipeline pattern](pipeline.md).

## Common Traps

| Trap                         | Pattern                                                 | Fix                                                       |
| ---------------------------- | ------------------------------------------------------- | --------------------------------------------------------- |
| **Stale CLAUDE.md**          | Project evolves but CLAUDE.md still describes v1        | Update CLAUDE.md in the same commit as structural changes |
| **README as dumping ground** | README accumulates architecture, history, and tutorials | Move architecture to SYSTEM.md, history to HANDOFF.md     |
| **Dual representation**      | Same fact in SYSTEM.md and a contract doc               | One source of truth per fact; the other points to it      |
| **Missing audience**         | One doc tries to serve agents, humans, and ops          | Separate documents for separate audiences                 |
| **Narrative HANDOFF.md**     | Long paragraphs instead of structured entries           | Datestamp, summary, changes, decisions, follow-up         |
| **Passive prose**            | "Configuration gets loaded by the service"              | "The service loads the configuration"                     |
| **Emdash creep**             | Emdashes appear in new docs from AI defaults            | Search for the long dash character; replace with `--`     |

## Questions to Ask

### When Writing

- Who reads this document -- agent, human, or both?
- Can a cold reader find the starting point in under 10 seconds?
- Does every sentence change what the reader does, or is it decoration?
- Are commands copy-pasteable, with exact versions and paths?

### When Inheriting

- Is CLAUDE.md current, or does `git log` show the project has moved past it?
- Does SYSTEM.md point to contracts, or does it restate them?
- Is HANDOFF.md newest-first, and does the top entry match the actual state?
- Are cross-project conventions (commits, emdash ban, Strunk's style) present?

### Periodically

- Do any docs reference retired project names or archived components?
- Has a CLAUDE.md grown sections that belong in README.md or SYSTEM.md?
- Are HANDOFF.md entries accumulating without anyone reading them?
- Has the writing style drifted from active voice and positive form?

---

_"Vigorous writing is concise. A sentence should contain no unnecessary words, a
paragraph no unnecessary sentences."_ -- William Strunk Jr.
