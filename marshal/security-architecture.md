# Security Architecture

Every boundary is a question: prove you belong here.

## What Security Architecture Covers

| Security Architecture Is                          | Security Architecture Isn't                                 |
| ------------------------------------------------- | ----------------------------------------------------------- |
| Layered trust boundaries between agents and tools | Risk judgment about whether to proceed ([risk.md](risk.md)) |
| How the two layers compose into defense in depth  | Implementation detail of any single layer                   |
| The principle that agents prove access at every   | A single perimeter with nothing behind it                   |
| The map connecting hook and credential mechanisms | Operational runbooks for each component                     |

**The test:** Can an agent explain what it's allowed to do, and can you verify
that claim without trusting the agent? If both answers are yes, the architecture
holds.

## The Two Layers

For trusted agents running in controlled environments, two layers provide
adequate security without the complexity of custom credential brokers.

### Layer 1: Marshal Hook (PreToolUse)

First line of defense. Blocks destructive commands before execution using
deterministic pattern matching -- `jq` piped to `grep -qEf`, not an LLM. Zero
cost, instant, no hallucinated approvals.

| Property          | Detail                                                       |
| ----------------- | ------------------------------------------------------------ |
| **Trigger**       | PreToolUse event in Claude Code                              |
| **Mechanism**     | Regex patterns in `.claude/marshal-blocks`                   |
| **What it stops** | Force push, hard reset, `rm -rf`, branch delete, `git clean` |
| **Cost**          | Zero -- deterministic grep, no API calls                     |
| **Scope**         | Local developer environment                                  |

The hook intercepts. It does not authenticate, authorize, or audit. Those
responsibilities belong to deeper layers.

### Layer 2: Standard GitHub Authentication

For trusted agents, use GitHub's built-in authentication mechanisms:

| Method                     | Best For                              | Scope Control                  |
| -------------------------- | ------------------------------------- | ------------------------------ |
| **SSH Agent Forwarding**   | Local development, trusted containers | User's full SSH access         |
| **Fine-Grained PATs**      | CI/CD, automated agents               | Per-repo, specific permissions |
| **GitHub Apps**            | Organization-wide automation          | Installation-scoped            |
| **GITHUB_TOKEN (Actions)** | GitHub Actions workflows              | Workflow-scoped, auto-rotated  |

See the agent-credentials initiative for implementation guidance.

## Trust Boundary Map

| Layer                   | Trusts                                 | Does Not Trust                         |
| ----------------------- | -------------------------------------- | -------------------------------------- |
| **Marshal Hook**        | Pattern file, Claude Code event system | Agent commands, commit message content |
| **GitHub Auth**         | GitHub's token validation              | Token storage by agents                |
| **Repository Settings** | Branch protection rules                | Push requests from any source          |

Each layer trusts the layer above it for one thing and nothing else.

## Data Flow

A git push from an agent traverses the security layers:

```text
Agent Process
    │
    │  1. git push origin feature/x
    │
    ├──> Marshal Hook (PreToolUse)
    │        │
    │        ├── grep -qEf marshal-blocks
    │        └── PASS (not a blocked pattern)
    │
    ├──> GitHub Authentication
    │        │
    │        ├── SSH key or token validated by GitHub
    │        └── Push proceeds if authenticated
    │
    └──> GitHub Branch Protection
             │
             ├── Required reviews enforced
             ├── Status checks must pass
             └── Force push blocked on protected branches
```

The hook ensures destructive patterns never execute locally. GitHub's auth
ensures identity. Branch protection ensures policy at the remote.

## Design Principles

| Principle                    | Mechanism                                         |
| ---------------------------- | ------------------------------------------------- |
| **Least privilege**          | Fine-grained PATs scope to specific repos/actions |
| **Defense in depth**         | Hook + auth + branch protection -- layered        |
| **Leverage platform**        | GitHub's auth is battle-tested; don't rebuild it  |
| **Deterministic over smart** | Regex beats LLM for blocking                      |
| **Fail closed**              | Invalid token = denied; protected branch = denied |

**The test:** Remove any single layer. Does the system still contain blast
radius? If yes, defense in depth holds.

## Common Traps

| Trap                       | Pattern                                       | Fix                                        |
| -------------------------- | --------------------------------------------- | ------------------------------------------ |
| **Overly broad PATs**      | Classic PAT with full repo access             | Use fine-grained PATs with minimal scope   |
| **Stale patterns**         | New destructive command not in marshal-blocks | Review patterns when tooling changes       |
| \*\*Missing branch protect | Main branch accepts direct push               | Enable branch protection on default branch |
| **Token in code**          | PAT committed to repository                   | Use environment variables or secret stores |
| \*\*SSH key without phrase | Unprotected private key                       | Use passphrase or hardware key             |

## Questions to Ask

### When Deploying

- Does the agent use the minimum credential scope needed?
- Are branch protection rules enabled on protected branches?
- Is the marshal-blocks file tested against false positives?
- Are credentials stored securely (not in code or logs)?

### When Auditing

- Do GitHub audit logs show expected access patterns?
- Has the hook blocked anything unexpected?
- Are any PATs older than rotation policy allows?

### Periodically

- Do branch protection rules match the current branching strategy?
- Are new agent types using appropriate credential scopes?
- Does removing one layer still leave adequate protection?

## Why Not a Custom Credential Stack?

We previously designed a four-layer system with credential broker, git proxy,
and container auth. Analysis revealed overengineering for trusted agents:

- **Complexity cost**: Three custom components to maintain
- **Attack surface**: Custom auth code is a liability, not an asset
- **Solved problem**: GitHub's auth mechanisms already handle credential scoping
- **Trust model**: Our agents run in trusted environments, not adversarial ones

For untrusted or multi-tenant agent scenarios, revisit the credential isolation
architecture. For trusted agents, standard GitHub auth with local hooks provides
adequate security with minimal maintenance burden.

---

_"Simplicity is the ultimate sophistication."_ -- Leonardo da Vinci
