# Context Hygiene

Agent context decays. Without maintenance, memory files accumulate stale
entries, orphan references, and duplicated instructions until they consume more
context than they provide.

## What Context Hygiene Is / Isn't

| Context Hygiene Is                                 | Context Hygiene Isn't                    |
| -------------------------------------------------- | ---------------------------------------- |
| Periodic review of what agents carry into sessions | Automated rewriting of memory content    |
| Pruning completed items and deleting orphans       | Eliminating memory files entirely        |
| Moving misplaced content to where it belongs       | A one-time cleanup pass                  |
| Maintaining the signal-to-noise ratio over time    | Rewriting history or removing all detail |

**The test:** Open a MEMORY.md file. If more than a third of its entries
describe resolved problems or reference renamed projects, the file costs more
tokens than it earns.

## Two File Types, Two Voices

CLAUDE.md and MEMORY.md serve different purposes. Mixing them degrades both.

|                      | CLAUDE.md                           | MEMORY.md                            |
| -------------------- | ----------------------------------- | ------------------------------------ |
| **Voice**            | "Do this" (instructions)            | "We learned this" (lessons)          |
| **Content**          | Architecture, commands, conventions | Gotchas, patterns, open threads      |
| **Never contains**   | Session history, resolved items     | Architecture, file layouts, CLI docs |
| **Prune signal**     | Project changes                     | Session end, rename, archive         |
| **Update frequency** | When structure changes              | When lessons crystallize or expire   |

**The discipline:** Before writing an entry, ask which file it belongs in. An
architectural decision goes in CLAUDE.md. The gotcha you discovered while
implementing it goes in MEMORY.md.

## Five Decay Patterns

Context does not rot at random. It decays in five predictable ways.

| Pattern               | Mechanism                                          | Example                                         |
| --------------------- | -------------------------------------------------- | ----------------------------------------------- |
| **Orphan files**      | Memory outlives the project it describes           | MEMORY.md references a deleted repo             |
| **Ghost names**       | Archived or renamed projects referenced silently   | "Lineage" appearing 40 sessions after rename    |
| **Stale markers**     | "Fixed in commit X" and "Resolved" items linger    | A "pending config update" resolved months ago   |
| **Scope creep**       | Architecture docs drift into MEMORY.md             | Ecosystem tables duplicated across both files   |
| **Misplaced content** | Insights land where written, not where they belong | A Lore gotcha recorded in Council's memory file |

**Ghost names** compound the worst. Each archived project leaves references
across docs, contracts, and memory files. Without a sweep, agents inherit a
vocabulary that no longer maps to reality.

## The Maintenance Cycle

Three tools form a maintenance loop. Each catches what the others miss.

| Tool              | When It Runs      | What It Does                                    |
| ----------------- | ----------------- | ----------------------------------------------- |
| `/capture-memory` | During sessions   | Dedup guard, routing check, size check on write |
| `/retro`          | End of session    | Memory health check, prune nudge                |
| `/memory-audit`   | Periodic (manual) | Orphan scan, ghost names, staleness, overlap    |

```text
Write (capture-memory) --> Accumulate --> Review (retro) --> Deep Clean (memory-audit)
  |                                                                    |
  +----------------------- Feedback Loop ------------------------------+
```

**`/capture-memory`** is the write guard. It prevents duplicates at entry time,
checks whether the insight belongs in CLAUDE.md or MEMORY.md, and warns when the
file exceeds a size threshold.

**`/retro`** nudges at session boundaries. It surfaces memory health -- how many
entries look stale, how large the file has grown -- and offers a prune option.

**`/memory-audit`** is the deep clean. It scans for orphan files, ghost names,
resolved items, and content that belongs elsewhere. Run it when a project
renames, archives, or restructures.

## Common Traps

| Trap                            | Pattern                                                    | Fix                                                  |
| ------------------------------- | ---------------------------------------------------------- | ---------------------------------------------------- |
| **LLM-driven curation**         | Using a model to decide what to keep                       | Deterministic guards beat LLM judgment for patterns  |
| **Session-log format**          | Append-only entries with no pruning signal                 | Write lessons, not events; lessons have expiry dates |
| **Duplicating for convenience** | Copying CLAUDE.md content into MEMORY.md                   | Cross-link; one source of truth per fact             |
| **Cleanup avoidance**           | Treating memory as append-only because pruning is scary    | Pruning stale entries is not losing knowledge        |
| **Audit without action**        | Running `/memory-audit`, reading the report, doing nothing | Budget 15 minutes to act on what the audit finds     |

## Questions

### After Each Session

- Did any insight land in the wrong file?
- Does MEMORY.md still fit in a single read, or has it grown past usefulness?

### After a Project Change

- Do any memory files reference the old name, path, or structure?
- Should you prune, merge, or archive an orphaned memory file?

### Periodically

- Which MEMORY.md entries describe problems already solved?
- Is the maintenance cycle running, or have the tools gone dormant?

---

_"The palest ink is better than the best memory."_ -- Chinese proverb. But only
if someone maintains the ink.
