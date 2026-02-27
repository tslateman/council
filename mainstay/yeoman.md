# Yeoman

> Examples reference Mirror and Neo (archived). The yeoman sync pattern remains
> valid -- apply it to whatever data bridges replace them.

Data carried faithfully arrives intact; data transformed en route arrives late.

## What a Yeoman Is

| Yeoman Is                                      | Yeoman Isn't                           |
| ---------------------------------------------- | -------------------------------------- |
| Thin sync script carrying data between systems | A worker executing tasks               |
| Manual invocation on the operator's schedule   | A daemon polling for changes           |
| Idempotent (re-running produces no duplicates) | A pipeline transforming data at stages |
| Silent on failure (warn and continue)          | A gatekeeper blocking on errors        |
| Dependent only on source project's CLI         | A new service introducing dependencies |

**The test:** Does the script read from one known path, write to one known
destination, and carry the data without transforming it? If yes, it's a yeoman.
If it decides what to carry, transforms the payload, or chains into further
processing, it's a pipeline stage wearing a yeoman's hat.

## Problem

Systems capture data. Other systems need that data. Without a carrier, operators
copy manually or build integration services that grow into their own maintenance
burden. The gap between "data exists" and "data is available where it matters"
is invisible per session and significant across fifty.

A pipeline is overkill when no transformation occurs. A daemon is overkill when
manual invocation suffices. A worker is wrong because there is no task to
execute -- only data to deliver.

## Solution

A thin script that reads from a known source path and writes to a known
destination. No transformation, no daemon, no polling, no new dependencies
beyond the source project's CLI. The operator invokes it when ready. Re-running
is safe. Failure warns but never blocks.

The name comes from Starfleet -- the officer who carries PADDs between people.
Quiet, reliable, invisible when working.

## Anatomy

### Data Flow

A yeoman is a line with two endpoints and a tracking file.

```text
Source Path ──[read]──> Yeoman Script ──[write]──> Destination
                             |
                        Marker File
                    (last-synced state)
```

The marker file makes re-running safe. The yeoman reads only items after the
marker, writes them forward, and advances the marker. No duplicates. No missed
items.

### Contract Surface

| Component       | What It Knows                | What It Doesn't Know          |
| --------------- | ---------------------------- | ----------------------------- |
| **Source**      | Its own data format          | That a yeoman reads from it   |
| **Yeoman**      | Source path, destination CLI | What source or destination do |
| **Destination** | Its own CLI interface        | Where the data originated     |
| **Marker file** | Last-synced identifier       | Anything about the data       |

The source and destination operate independently. Neither knows the other
exists. The yeoman knows both addresses but understands neither system's
internals.

### Properties

Every yeoman satisfies six constraints:

| Property     | Constraint                                        |
| ------------ | ------------------------------------------------- |
| Trigger      | Manual invocation (not polling, not daemon)       |
| Input        | Single known file path                            |
| Output       | Single known destination (CLI call or file write) |
| Idempotency  | Re-running produces no duplicates                 |
| Failure mode | Warn and continue (never block the caller)        |
| Dependencies | Source project's CLI only (no new packages)       |

Violate any one and the script is no longer a yeoman. Adding a polling loop
makes it a daemon. Adding transformation makes it a pipeline stage. Adding task
execution makes it a worker.

## Implementation

### Field Mapping

Each yeoman needs a mapping table: source fields to destination fields. The
mapping may concatenate, rename, or restructure, but the data content passes
through unchanged.

Example from the Mirror to Lore yeoman:

| Mirror Field    | Lore Field       | Transform                           |
| --------------- | ---------------- | ----------------------------------- |
| `title + chose` | `decision`       | Concatenate: "title: chose"         |
| `reasoning`     | `--rationale`    | Direct                              |
| `alternatives`  | `--alternatives` | Join array                          |
| `category`      | `--type`         | Map to Lore types                   |
| `tags`          | `--tags`         | Direct, append project name         |
| `id`            | (tracking)       | Store last-synced ID to avoid dupes |

**The discipline:** Field mapping is structural, not semantic. The yeoman
translates field names and formats. It never interprets, filters, or enriches
the data.

### Tracking State

A single marker file prevents duplicate syncing. The marker contains the
identifier of the last successfully synced item.

```text
~/.mirror/.lore-sync-marker       # Mirror → Lore
missions/.last-dispatched          # Lore Intent → Neo (planned)
```

The yeoman reads items after the marker, processes them sequentially, and
advances the marker after each successful write. If a write fails, the marker
stays put and the yeoman warns. The next invocation retries from the same point.

### Error Handling

Yeomen fail gracefully. The hierarchy:

| Failure                     | Response                                  |
| --------------------------- | ----------------------------------------- |
| Source file missing         | Warn, exit 0                              |
| Destination CLI unavailable | Warn, exit 0                              |
| Single item fails to sync   | Warn, skip, continue with remaining items |
| Marker file missing         | Treat as first run, sync everything       |
| Marker file corrupted       | Warn, treat as first run                  |

**The principle:** A yeoman never blocks the caller. An operator running a
yeoman as part of a larger workflow should not lose the workflow because one
sync target was temporarily unavailable.

## Used In

| Yeoman        | Source                     | Destination                         | Status                              |
| ------------- | -------------------------- | ----------------------------------- | ----------------------------------- |
| Mirror → Lore | `~/.mirror/judgments.yaml` | `lore remember` CLI                 | Archived (reference implementation) |
| Lore → Neo    | `intent/active/*.yaml`     | `spawn-team-cc.sh` or contract file | Planned                             |

The yeoman pattern originated in the Feedback Loop initiative. Mainstay owns the
pattern definition; Mentor owns the first implementation (Mirror to Lore).

The [pipeline](pipeline.md) connects stages that transform data. The
[worker](worker.md) executes tasks statelessly. The yeoman carries data between
existing systems that neither transform nor execute -- they just need the data
to arrive.

## Common Traps

| Trap                        | Pattern                                         | Fix                                              |
| --------------------------- | ----------------------------------------------- | ------------------------------------------------ |
| **Scope creep to pipeline** | Yeoman starts filtering or enriching data       | If it transforms, extract a pipeline stage       |
| **Daemon drift**            | Manual script gets wrapped in a cron job        | Manual invocation is a feature, not a limitation |
| **Missing marker**          | No tracking file; duplicates on every run       | Marker file is mandatory, not optional           |
| **Blocking on failure**     | Script exits non-zero when destination is down  | Warn and continue; exit 0                        |
| **Dependency creep**        | Yeoman requires packages beyond source CLI      | One dependency rule: source project's CLI only   |
| **Invisible coupling**      | Source changes format; yeoman silently corrupts | Field mapping table is the contract; version it  |

## Questions to Ask

### When Designing

- Does the data need transformation, or just delivery? If transformation, use a
  pipeline stage instead.
- What is the marker? A sequential ID, a timestamp, a hash?
- What happens if the destination is temporarily unavailable?
- Does the source project's CLI provide everything the yeoman needs?

### When Inheriting

- Where does the marker file live, and what format does it use?
- What is the field mapping, and where is it documented?
- How does the yeoman handle items that fail to sync?
- Is the script still a yeoman, or has it grown into a pipeline stage?

### Periodically

- Has the source format changed since you wrote the field mapping?
- Are there items stuck behind a failed marker?
- Is anyone tempted to add a polling loop?
- Does the yeoman still carry data unchanged, or has filtering crept in?

---

_"The bearing of a child takes nine months, no matter how many women are
assigned."_ -- Fred Brooks
