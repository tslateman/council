# Operations

Trust nothing. Verify everything. Log what happened.

## What Operations Covers

| Operations Is                                   | Operations Isn't                                                   |
| ----------------------------------------------- | ------------------------------------------------------------------ |
| Mechanisms that enforce security at runtime     | Judgment about whether to proceed ([risk.md](risk.md) covers that) |
| Deterministic checks an agent cannot bypass     | Heuristic analysis requiring human review                          |
| Scoped, time-limited, auditable access          | Broad permissions granted once and forgotten                       |
| Blast radius reduction through layered controls | A single perimeter with nothing behind it                          |

**The test:** Can an agent explain what it's allowed to do, and can you verify
that claim without trusting the agent? If both answers are yes, the operational
controls hold.

## Two Domains

### Credential Delegation

For trusted agents, use standard GitHub authentication:

| Method                   | When to use                       | Setup                                     |
| ------------------------ | --------------------------------- | ----------------------------------------- |
| **SSH agent forwarding** | Local development, aoe containers | `docker run -v $SSH_AUTH_SOCK:/ssh-agent` |
| **GitHub App tokens**    | CI/CD, automated pipelines        | Install app, mint installation tokens     |
| **Fine-grained PATs**    | Simple automation, single-repo    | Create in GitHub settings, set expiry     |

| Principle               | Mechanism                                           |
| ----------------------- | --------------------------------------------------- |
| **Least privilege**     | Fine-grained PATs scope to specific repos           |
| **Time-limited access** | Token expiration (PATs) or 1-hour TTL (GitHub Apps) |
| **Branch restriction**  | GitHub branch protection rules                      |
| **Audit trail**         | GitHub security log for organization accounts       |

See the agent-credentials initiative for guidance on which method to use.

### Hook Design

The marshal hook blocks destructive commands before they execute. It uses
deterministic pattern matching -- `jq` piped to `grep -qEf` -- not an LLM. Zero
cost, instant, no false negatives from model variance.

| Design Choice              | Why                                                    |
| -------------------------- | ------------------------------------------------------ |
| **Regex patterns**         | Deterministic, auditable, version-controlled           |
| **Anchored patterns**      | `^rm\s+-rf` prevents matching prose in commit messages |
| **Configurable blocklist** | `.claude/marshal-blocks` -- one regex per line         |
| **PreToolUse event**       | Intercepts before execution, not after                 |
| **grep over LLM**          | Zero-cost, instant, no hallucinated approvals          |

Git tracks the pattern file. Git ignores the hook configuration
(`settings.local.json`) -- cloning the repo gives you the patterns but not the
wiring. `make setup` bridges this gap for new contributors.

**Current patterns block:** force push, hard reset, `rm -rf` (at line start and
after command separators), branch force-delete, `git clean -f`, and
`git checkout .`. See [test coverage](../tests/test-marshal-hook.sh) for the
full matrix.

## How the Domains Connect

```text
Agent Session
    │
    ├── git commands ──> GitHub (via SSH/HTTPS)
    │                       │
    │                       └── GitHub branch protection enforces policy
    │
    └── destructive commands ──> Marshal Hook (PreToolUse)
                                    │
                                    └── grep -qEf marshal-blocks
```

GitHub enforces remote policy. The marshal hook intercepts local destructive
commands. Two layers, two concerns, one principle: verify before execute.

## Common Traps

| Trap                           | Pattern                                            | Fix                                                  |
| ------------------------------ | -------------------------------------------------- | ---------------------------------------------------- |
| **Over-broad patterns**        | Unanchored regex blocks legitimate commit messages | Anchor patterns to command position (`^rm\s+-rf`)    |
| **Tokens without expiry**      | PAT created with no expiration date                | Always set expiration; prefer GitHub Apps for CI     |
| **Hook blocks its own commit** | Pattern file contains terms the hook matches       | Test with `make test` before committing hook changes |
| **Single-layer defense**       | GitHub protection without local hook               | Layer controls -- each catches what others miss      |

## Questions to Ask

### When Deploying

- Does the agent use the minimum credential scope it needs?
- Are token expirations short enough for the task duration?
- Is the marshal-blocks file tested against false positives?

### When Auditing

- Do GitHub security logs show expected access patterns?
- Are any PATs active past their expected lifetime?
- Has the hook blocked anything unexpected, suggesting a pattern needs tuning?

### Periodically

- Are marshal-blocks patterns still anchored correctly as new commands emerge?
- Have any PATs outlived their projects?
- Do branch protection rules match the current branching strategy?

---

_"Quis custodiet ipsos custodes?"_ -- Juvenal
