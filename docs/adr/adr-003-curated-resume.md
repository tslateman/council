# Curated Resume

## Status

Accepted

## Context

Lore remembers everything but curates nothing at session start. `lore recall`
has a sophisticated 6-factor FTS5 ranking formula (BM25, temporal decay, access
frequency, importance, recent access boost, project affinity). `lore resume`
ignores it entirely -- displaying parent session fields sequentially and falling
back to chronological last-5-of-each-type when the session is sparse.

The ranking engine and the session loader are separate codepaths that never
meet. The curation gap lives in the wiring, not the algorithm.

### Forces

| Force                                | Direction                    |
| ------------------------------------ | ---------------------------- |
| FTS5 6-factor ranking already exists | Toward wiring, not designing |
| Resume context string already built  | Toward wiring, not designing |
| No intent signal without spec layer  | Against algorithmic curation |
| Access logging never reaches resume  | Toward closing the loop      |
| 5 retrieval paths, 5 ranking systems | Against adding a 6th path    |
| Unresolved review backlog            | Against trusting quality now |
| Sessions immutable after fork        | Toward read-time computation |

## Options Evaluated

| Option                              | Verdict     | Rationale                                                                                                                |
| ----------------------------------- | ----------- | ------------------------------------------------------------------------------------------------------------------------ |
| **Wire FTS5 into resume**           | **Adopted** | ~20 lines. Resume already builds context_parts; search-index.sh accepts CLI queries. Two-way door.                       |
| **Persistent salience score**       | Deferred    | New table, update logic, decay job. Requires evidence that formula-based ranking fails. Revisit after 2-4 weeks of data. |
| **LLM-in-the-loop curation**        | Rejected    | Latency and cost for a command that should return in <1s. Violates the bash CLI constraint.                              |
| **Embedding-based similarity**      | Rejected    | Adds Python/ML dependency to a bash CLI. FTS5 handles current data volume.                                               |
| **Separate "curate" verb**          | Rejected    | Violates the 5-verb contract. Curation is a property of resume and recall, not a distinct action.                        |
| **Consolidate all retrieval first** | Deferred    | Desirable but orthogonal. The new code composes on FTS5 rather than adding a parallel scorer.                            |

## Decision

Wire the existing FTS5 ranked search into `resume_session()`. Replace the
chronological sparse fallback with a context-derived ranked query. Log access
for every item surfaced. Measure results before adding complexity.

The context string already exists at `transfer/lib/resume.sh:690-706` --
project, summary, and open threads concatenated for
`suggest_patterns_for_context`. Pass the same string to `search-index.sh search`
instead.

### Evaluate-Before-Extending Gate

After 2-4 weeks of ranked resume:

- If surfaced items consistently match what the user needs: stop.
- If the access log shows items surfaced but never engaged: add negative signal
  (the reinforcement loop's missing half).
- If ranked results cluster around recent items at the expense of structurally
  relevant older ones: evaluate graph proximity and unseen boost factors.
- If unresolved decisions dominate results: address the review backlog first.

## Consequences

### What We Gain

- Resume surfaces the 10 most relevant items across all components, ranked by
  the same formula recall uses
- The reinforcement loop extends to resume (access logging on surfaced items)
- No new tables, dependencies, or retrieval paths
- Data to evaluate whether persistent salience scoring is worth building

### What We Accept

- FTS5 keyword matching on context strings may surface tangentially related
  items (false positives in a top-10 list are cheap -- the user ignores them)
- Without widespread spec adoption, the context query may lack intent signal
- The review backlog continues to affect quality of importance scores upstream

### Trade-offs Named

| We Chose               | Over                        | Because                                                        |
| ---------------------- | --------------------------- | -------------------------------------------------------------- |
| Wiring existing scorer | Building new curation layer | The infrastructure exists; the gap is plumbing                 |
| Context-derived query  | User-supplied intent        | Resume runs at session start without user input                |
| Log access on display  | Full reinforcement loop     | Positive signal first; negative signal after data justifies it |
| Formula-based ranking  | ML/embedding approaches     | Bash CLI constraint; FTS5 handles current volume               |

## Council Input

| Seat      | Position                                                                                                                                                                                                                                             |
| --------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Critic    | Wire FTS5 and stop. The framing invents a design problem where a wiring gap exists. The real risk: no negative signal in the reinforcement loop, and the review backlog poisons quality. Measure before extending.                                   |
| Wayfinder | Context-derived query first (Approach A). Persistent salience score only if data proves A insufficient (Approach B). The elegant path: start simple, let the data decide.                                                                            |
| Mainstay  | Curation is a read-only stage in the resume pipeline. It queries existing stores, computes a ranking, returns text. Adjacent-only coupling to search index and session store. One new function, one caller. Extract only if a second caller appears. |

### Dissent

The Critic warns that without negative signal (items surfaced but ignored), the
access frequency factor degrades into a popularity contest with survivorship
bias. If the user remains unsatisfied after wiring, the problem is the absence
of an intent signal, not the ranking formula.

## Pre-Mortem

Six months from now, curated resume has failed. Most likely causes:

1. The context string is too broad (project name + summary + threads), producing
   noisy FTS5 matches that the user learns to ignore
2. The review backlog means importance scores are stale defaults, so ranking
   computes precise scores from imprecise inputs
3. Spec adoption stays low, removing the strongest intent signal
4. Nobody built negative signal, so the reinforcement loop rewards presence over
   usefulness
