# Contributing to Council

Advisory layer for cross-project decisions. Council advises, tracks initiatives,
and maintains frameworks. It does not execute work.

## Setup

```bash
make setup   # install git hooks, sync vale
make test    # security + orchestration tests
make check   # format + lint + prose + links
make status  # initiative acceptance criteria progress
```

## Code Style

| Convention    | Rule                                           |
| ------------- | ---------------------------------------------- |
| Documentation | Markdown with tables, bold key terms           |
| Configuration | TOML for config, YAML for registries           |
| Shell scripts | `set -euo pipefail`                            |
| Prose         | Strunk's Elements of Style -- active, concrete |
| Emdashes      | Never. Use double hyphens (`--`) instead       |
| Opening lines | Short, punchy thesis                           |
| Structure     | Thesis, Is/Isn't, mechanics tables, traps, Qs  |

## Commits

Use conventional prefixes with Strunk's-style body:

```text
docs: Add critique framework for proposal review
feat: Add initiative tracker for feedback loop
test: Cover marshal hook edge cases
```

Active voice. Omit needless words. No `Co-Authored-By` signatures.

## Seat Placement

Content belongs in the seat directory whose mandate it serves:

| Seat           | Mandate              |
| -------------- | -------------------- |
| **Critic**     | Discipline of Doubt  |
| **Mentor**     | Continuity of Wisdom |
| **Wayfinder**  | Logic of Discovery   |
| **Marshal**    | Security of Action   |
| **Mainstay**   | Structural Anchor    |
| **Ambassador** | Voice Beyond         |

If unsure where content belongs, the seat mandate decides.

## Initiatives

Cross-project work lives in `initiatives/<name>.md` with an accountable seat.
Track acceptance criteria with checkboxes. Run `make status` to check progress.

## Pull Requests

1. Branch from `main` with a descriptive name
2. Keep changes focused -- one concern per PR
3. Run `make check` before submitting
4. Cross-link rather than duplicate -- each link marks a boundary
5. Plan files go in the target project's `plans/` directory

## Integration Pattern

Council integrates with optional ecosystem tools (Lore, Neo) through graceful
degradation: check availability, use if present, skip silently if absent.

```bash
# Canonical pattern -- see hooks/pre-commit:28-34
TOOL="$HOME/dev/lore/lore.sh"
if [[ -x "$TOOL" ]]; then
    "$TOOL" observe "$title" 2>/dev/null || true
fi
```

Three rules:

1. **Check with `-x`** -- confirms the tool exists and is executable
2. **Redirect stderr** -- suppress noise when the tool misbehaves
3. **Trail with `|| true`** -- never let an optional tool break the workflow

The pre-commit hook (`hooks/pre-commit:28-44`) demonstrates this pattern for
Lore integration. All ecosystem integrations should follow it.

## What Not to Do

- Don't execute work -- Council advises only
- Don't duplicate content across seat directories -- cross-link
- Don't use absolute paths in markdown (breaks link checkers)
