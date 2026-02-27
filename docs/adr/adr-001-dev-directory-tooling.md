# Dev Directory Navigation Tooling

## Status

Accepted

## Context

The `~/dev` directory holds ~30 active projects. Navigation relies on raw `cd`
and `wd` bookmarks. Research surfaced six tools (zoxide, ghq, gita, mani, gwq,
fzf) for improving multi-repo workflows — directory jumping, bulk git
operations, structured clone layouts, and fuzzy selection.

The existing principles constrain the decision:

- **Workbench not warehouse** — keep project count low, archive stale work
- **Flat `~/dev` layout** — fast traversal, low ceremony
- **Lore owns project registry** — single source of truth for what exists and
  how projects relate
- **`~/dev/...` cross-repo links** — lychee and docs depend on this convention

## Options Evaluated

| Tool       | Purpose                          | Verdict      | Rationale                                                              |
| ---------- | -------------------------------- | ------------ | ---------------------------------------------------------------------- |
| **zoxide** | Frecency-based directory jump    | **Adopted**  | Zero config, immediate payoff, layers on without changing anything     |
| **gita**   | Git-aware dashboard across repos | Rejected     | Overlaps with Lore; two registries drift                               |
| **ghq**    | Clone repos into host/owner/repo | Rejected     | Solves name-collision problem we don't have; migration cost high       |
| **mani**   | Declarative cross-repo commands  | Rejected     | YAML config adds maintenance for infrequent use                        |
| **gwq**    | Worktree manager with fzf        | Rejected     | Premature; no current pain around worktrees                            |
| **fzf**    | Fuzzy finder for composing tools | **Deferred** | Useful glue, but no immediate need; revisit when composability matters |

## Decision

Adopt zoxide as the sole new navigation tool. Keep `wd` (explicit bookmarks)
alongside it — they complement rather than conflict.

Skip ghq, gita, and mani. The flat `~/dev` layout works because discipline keeps
the count low, not because directory depth solves discovery. Lore should absorb
gita's "status across all repos" capability via a future `lore status` command
rather than introducing a parallel registry.

Defer fzf until a concrete need arises (interactive selection from piped lists,
`zi` interactive mode, or `git branch | fzf` workflows).

## Consequences

- zoxide learns from usage with zero maintenance — no bookmarks to curate
- `wd` remains available for deterministic jumps to curated locations
- Lore gains a clear next feature (`lore status`) instead of delegating to gita
- ghq's host/owner/repo structure stays off the table, preserving the flat
  layout and existing `~/dev/...` link convention
- fzf deferred means `zi` (zoxide interactive) won't work until installed

## Council Input

| Seat       | Position                                                                |
| ---------- | ----------------------------------------------------------------------- |
| Mainstay   | zoxide yes; gita no — Lore owns project awareness, one registry         |
| Critic     | ghq solves wrong problem; flat layout works because of discipline       |
| Marshal    | zoxide low risk; ghq migration breaks scripts, configs, link convention |
| Wayfinder  | zoxide + Lore status = full coverage with minimal tooling               |
| Mentor     | Simplicity transfers; flat dir + registry learnable in minutes          |
| Ambassador | No strong opinion; conventional layout easier to publish but not needed |
