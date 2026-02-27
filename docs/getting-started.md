# Getting Started with Council

Six seats. Six questions. Every decision gets the right challenge.

Council is an advisory framework for making better decisions. Each seat asks one
question that prevents a specific failure mode.

| Seat           | Core Question                      | Prevents                     |
| -------------- | ---------------------------------- | ---------------------------- |
| **Critic**     | "What are we refusing to see?"     | Unchallenged assumptions     |
| **Wayfinder**  | "What's the elegant path through?" | Brute-force solutions        |
| **Marshal**    | "What's the risk, and am I ready?" | Unexamined risk              |
| **Mainstay**   | "What holds this together?"        | Structural drift             |
| **Mentor**     | "Who will carry this forward?"     | Knowledge that dies with you |
| **Ambassador** | "How does the world see us?"       | Isolation from users         |

Each seat directory contains frameworks: decision models, trade-off tables,
common traps, and diagnostic questions.

---

## Install

```bash
git clone <council-repo-url>
cd council
```

Council is documents and agents, not a runtime. Verify the structure:

```bash
ls critic/ marshal/ wayfinder/ mainstay/ mentor/ ambassador/
```

Optional -- install git hooks for commit-level seat tracking:

```bash
make setup
```

---

## Use the Six Seats

### Step 1: Identify the Decision Type

| Type             | Reversibility | Response                                          |
| ---------------- | ------------- | ------------------------------------------------- |
| **One-way door** | Hard/costly   | Invoke Critic + Marshal before proceeding         |
| **Two-way door** | Easy/cheap    | Decide fast, document rationale                   |
| **Sliding door** | Window closes | Recognize the deadline, then apply the right seat |

### Step 2: Pick the Right Seat

| Situation                              | Read          |
| -------------------------------------- | ------------- |
| Choosing between approaches            | `critic/`     |
| New or unfamiliar territory            | `wayfinder/`  |
| Destructive or irreversible action     | `marshal/`    |
| Creating or modifying contracts        | `mainstay/`   |
| Writing docs or transferring knowledge | `mentor/`     |
| External-facing work (PRs, APIs)       | `ambassador/` |

### Step 3: Apply the Framework

Each seat directory contains frameworks with tables, traps, and questions. Read
the relevant file and work through its structure.

**Example:** You face two architectural approaches. Read `critic/decisions.md`.
The trade-off analysis table forces you to name what you're giving up. The
common traps table catches bike-shedding and premature commitment. The Critic's
strongest move: challenge the ranking metric, not just the options.

### With Claude Code Agents

If you use Claude Code, Council includes agents in `agents/` organized in three
tiers:

| Tier              | Purpose                           | Examples                               |
| ----------------- | --------------------------------- | -------------------------------------- |
| **Seats**         | Primary advisory -- invoke these  | `critic`, `marshal`, `mentor`          |
| **Workers**       | Shortcuts for specific seat tasks | `steelman`, `sentinel`, `socratic`     |
| **Orchestrators** | Coordinate across seats           | `council-advisor`, `council-synthesis` |

Invoke **seats** when you need advisory on a decision. Use **workers** as
shortcuts when your task maps directly to one -- steelmanning an alternative,
running a pre-mortem, reviewing an artifact for outsiders, pruning stale
knowledge. Use `council-advisor` when you're unsure which seat applies, or
`council-synthesis` to convene multiple seats for high-stakes decisions.

---

## Record Decisions

Decisions are invisible unless captured. Council uses two formats:

### Architecture Decision Records (ADRs)

For one-way doors and decisions others will question later. Store in
`wayfinder/`:

```markdown
# [Decision Title]

## Status: Accepted | Superseded | Deprecated

## Context: What forces are at play?

## Decision: What are we doing?

## Consequences: What trade-offs are we accepting?
```

### Initiatives

For cross-project problems that span weeks. Store in `initiatives/`:

| Element                 | Purpose                             |
| ----------------------- | ----------------------------------- |
| **Problem statement**   | What needs solving?                 |
| **Goals**               | What does success look like?        |
| **Acceptance criteria** | How do we know we're done?          |
| **Seat input**          | Which seats advised, what they said |

One initiative spawns multiple plans across multiple projects. The initiative
tracks the problem; each plan tracks one piece of work.

---

## Directory Map

| Path           | Contains                                    |
| -------------- | ------------------------------------------- |
| `critic/`      | Decision frameworks, disagreement, critique |
| `wayfinder/`   | Exploration frameworks, ADRs                |
| `marshal/`     | Risk assessment, security, operations       |
| `mainstay/`    | Structural patterns, contracts, ecosystem   |
| `mentor/`      | Knowledge transfer, documentation           |
| `ambassador/`  | External communication, PR review           |
| `agents/`      | Claude Code agent definitions               |
| `initiatives/` | Cross-project initiative tracking           |
| `charter.md`   | Seat mandates and oaths                     |

---

## Advanced: Ecosystem Integration

Council works standalone, but it can also serve as the advisory layer in a
larger agent stack. If you use these tools, Council integrates with them:

| Project    | Integration                                        |
| ---------- | -------------------------------------------------- |
| **Lore**   | Store decisions and patterns from council sessions |
| **Praxis** | Surface recurring failures for Marshal review      |
| **Geordi** | Visualize the decision graph                       |

These integrations are optional. Council's frameworks and agents function
without them.

### Pattern: Optional Integration

Ecosystem tools come and go. Council integrations degrade gracefully using three
rules: check availability, use if present, skip silently if absent. See
[CONTRIBUTING.md](../CONTRIBUTING.md#integration-pattern) (lines 67-87) for the
canonical pattern and code example.
