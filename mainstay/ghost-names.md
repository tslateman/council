# Ghost Names

Project names that no longer exist. Reference this when you encounter unfamiliar
names in old code, docs, or conversations.

## The Grand Simplification (2026-02-14)

Collapsed 16 projects to 6 core.

| Ghost Name | Now Lives In | What Moved                                             |
| ---------- | ------------ | ------------------------------------------------------ |
| Lineage    | **Lore**     | Renamed. Journal, patterns, graph, transfer            |
| Oracle     | **Lore**     | Intent goals and missions now in Lore intent/          |
| Old Lore   | **Lore**     | Registry now in Lore registry/                         |
| Monarch    | **Lore**     | Renamed to Lore during Grand Simplification            |
| Flow       | Archived     | State management absorbed into Neo, then both archived |
| Neo        | Archived     | Team orchestration. Contracts remain at `cli/neo/`     |
| Bach       | Archived     | Stateless worker theory. Never reached production      |
| Ralph      | Archived     | Loop driver superseded by Claude Code agent-teams      |
| Mirror     | Archived     | Judgment capture absorbed by Claude Memory             |

## The Test

If you reference Lineage, Oracle, Monarch, Flow, Neo, Bach, Ralph, Mirror, or
old Lore in new work, you are referencing a project that no longer exists. Use
the current name or remove the reference.

## Why This Matters

Ghost names cause confusion:

- Grep returns old results that mislead
- New contributors waste time searching for projects that don't exist
- AI agents hallucinate based on stale context

When you find a ghost name in active code, update it.

## File Renames

| Ghost Path        | Now Lives At         | Reason                                        |
| ----------------- | -------------------- | --------------------------------------------- |
| mentor/lineage.md | mentor/succession.md | Disambiguate from the Lineage-to-Lore project |
