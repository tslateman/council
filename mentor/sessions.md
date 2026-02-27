# Sessions

Every session that starts from zero wastes everything the last one learned.

## What a Session Is / Isn't

| Session Is                                      | Session Isn't                            |
| ----------------------------------------------- | ---------------------------------------- |
| A unit of work with state, handoffs, and memory | A conversation that evaporates on close  |
| Bounded by resume and handoff                   | Bounded by "hello" and "goodbye"         |
| Connected to past decisions via Lore            | Starting fresh each time                 |
| A link in a chain of compounding knowledge      | An isolated event                        |
| Accountable for what it captures before ending  | Free to leave without recording anything |

**The test:** If the next session can pick up where this one stopped -- with
open threads, recent decisions, and relevant patterns -- this was a session. If
the next session starts from scratch, this was a conversation.

## Session Lifecycle

Three phases. Each has a job.

```text
Resume ──> Work ──> Handoff
```

### Starting: Resume

The first command in any session loads context from previous work.

```bash
lore resume
```

This returns:

- **Open threads** -- unfinished work from the last session
- **Recent decisions** -- choices made, rationale given
- **Relevant patterns** -- validated lessons from past sessions

Without resume, the agent operates on what CLAUDE.md provides and nothing more.
Static context is the floor; session context is the ceiling. See
[Transfer](transfer.md) for how these layers interact.

#### What to check after resume

| Check                   | Why                                               |
| ----------------------- | ------------------------------------------------- |
| Open threads from prior | Decide: continue, defer, or close                 |
| Recent decisions        | Avoid relitigating settled questions              |
| Pattern suggestions     | Apply validated lessons before discovering them   |
| Git state               | Confirm you're on the right branch and up to date |

### During: Work

Capture as you go, not at the end. The discipline is recording while the
rationale is fresh -- not reconstructing it from memory during handoff.

#### What to capture

| Capture This                 | Command                      | Why                                                    |
| ---------------------------- | ---------------------------- | ------------------------------------------------------ |
| **Decisions with rationale** | `lore remember "<decision>"` | Rationale decays fastest; the decision persists        |
| **Patterns learned**         | `lore learn "<pattern>"`     | Validated lessons compound across sessions             |
| **Raw observations**         | `lore observe "<note>"`      | Staging area for things you noticed but can't classify |
| **Nothing else**             | --                           | Over-capturing creates noise that drowns signal        |

Decisions need rationale. "We chose X" is useless without "because Y." Always
pass `--rationale` when recording decisions.

```bash
lore remember "Chose YAML over TOML for registry format" \
  --rationale "YAML supports comments and multi-line strings; registry is human-edited" \
  --tags "lore,registry"
```

Patterns need context. A pattern without "when this applies" is a proverb, not
an operator guide.

```bash
lore learn "Contract-first interfaces" \
  --context "Multi-project systems with independent evolution" \
  --solution "Define markdown contracts at boundaries before implementing"
```

### Ending: Handoff

A session that ends without handoff breaks the chain. The next session starts
from zero.

```bash
lore handoff "<summary of where things stand>"
```

This captures:

- Current git state (branch, uncommitted changes)
- Active files in the working set
- Open threads -- what's unfinished, what's blocked, what's next
- A summary in your words

#### What makes a good handoff

| Good Handoff                                  | Bad Handoff                        |
| --------------------------------------------- | ---------------------------------- |
| "Auth middleware working; tests need mocking" | "Made progress on auth"            |
| Lists open threads explicitly                 | Assumes the next session remembers |
| Names blockers and next steps                 | Describes only what happened       |
| Under 200 words                               | Exhaustive play-by-play            |

**The discipline:** Write the handoff you'd want to receive.

## Operator Workflow

### Quick Reference

| When                   | Command                    | What It Does                           |
| ---------------------- | -------------------------- | -------------------------------------- |
| Session start          | `lore resume`              | Load context from previous session     |
| Decision made          | `lore remember "<text>"`   | Capture decision with rationale        |
| Pattern discovered     | `lore learn "<pattern>"`   | Capture reusable lesson                |
| Something noticed      | `lore observe "<text>"`    | Stage raw observation for later triage |
| Session end            | `lore handoff "<summary>"` | Create resumable snapshot              |
| Check session state    | `lore status`              | Show current session info              |
| Search past work       | `lore search "<query>"`    | Query across all Lore components       |
| Gather project context | `lore context <project>`   | Full context dump for a project        |

### Session Start Checklist

1. Run `lore resume`
2. Read open threads -- decide which to continue
3. Check pattern suggestions -- apply before rediscovering
4. Verify git state matches expectations
5. Begin work

### Session End Checklist

1. Review decisions made -- did you record rationale for each?
2. Capture any patterns learned during the session
3. Triage inbox observations (promote or discard)
4. Run `lore handoff` with a summary that names open threads
5. Verify the handoff captured correctly with `lore status`

## Integration with the Knowledge Stack

Sessions sit at the operational layer. They consume what the
[transfer](transfer.md) system delivers and produce what the
[lifecycle](../mainstay/lifecycle.md) system processes.

```text
CLAUDE.md (static) → lore resume (session) → Work → lore handoff (capture)
                                                          ↓
                                                  Memory → Lore → Formal Store
```

Static context (CLAUDE.md) loads every session. Session context (`lore resume`)
loads what's relevant from prior work. The
[lifecycle](../mainstay/lifecycle.md)'s sync-promote-execute model governs how
raw captures mature into trusted knowledge that reaches future sessions.

## Common Traps

| Trap                             | Pattern                                              | Fix                                                        |
| -------------------------------- | ---------------------------------------------------- | ---------------------------------------------------------- |
| **Skipping resume**              | Session starts from zero despite prior work existing | Make `lore resume` the first command, every time           |
| **Actions without rationale**    | Recording "chose X" without "because Y"              | Always pass `--rationale`; it decays faster than you think |
| **Handoff without open threads** | Summary describes what happened, not what's next     | Name unfinished work, blockers, and next steps             |
| **Over-capturing**               | Every observation recorded; signal drowns in noise   | Capture decisions and patterns; observe the rest           |
| **End-of-session memory dump**   | Reconstructing rationale after the fact              | Capture during work, not after                             |
| **Orphaned sessions**            | No handoff; next session can't find prior context    | Treat handoff as mandatory, not optional                   |

## Questions

### Before Starting

- Did the previous session leave open threads?
- Are there pattern suggestions relevant to today's work?
- Is the git state what the last handoff described?

### During Work

- Have I recorded the rationale for decisions made this session?
- Am I capturing patterns as I discover them, or deferring?
- Are my observations going to the inbox, or disappearing?

### Before Ending

- Would the next agent know where to pick up from my handoff?
- Did I name open threads, or just describe completed work?
- Is there anything in my head that should be in Lore?

---

_"The palest ink is better than the best memory."_ -- Chinese proverb
