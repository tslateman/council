# Config

Each format earns its place by what reads it.

## What Config Is

| Config Is                                           | Config Isn't                                |
| --------------------------------------------------- | ------------------------------------------- |
| A declaration read at startup or build time         | Runtime state that changes during execution |
| Scoped to a single concern (build, deploy, lint)    | A grab bag of unrelated settings            |
| Readable by its primary consumer without conversion | A format chosen for the author's preference |
| Versioned in git alongside the code it configures   | A secret store or credential vault          |

**The test:** Can you delete the config file, regenerate it from documented
conventions, and get the same behavior? If yes, the config is well-structured.
If regeneration requires tribal knowledge, the config has become implicit
documentation.

## Problem

A multi-project ecosystem accumulates configuration in every format: TOML, YAML,
JSON, environment variables, Makefiles. Without conventions, each project
invents its own layout. Agents entering a new project waste time discovering
where settings live, which tool reads which file, and whether a value is
authoritative or derived.

## Solution

Assign each format to the consumer that reads it natively. TOML for application
config (human-authored, tool-parsed). YAML for registries and data (structured,
cross-referenced). JSON for tool-generated config (machines write it, machines
read it). Makefiles for build entry points (developers type `make dev`, not a
12-flag command). Environment variables for deployment-time overrides.

## Format Assignments

### TOML: Application Configuration

TOML serves human-authored settings that a tool parses at startup.

```toml
# pyproject.toml -- Python project config (uv as package manager)
[project]
name = "geordi"
version = "0.1.0"
requires-python = ">=3.12"
dependencies = ["fastapi>=0.110.0", "uvicorn>=0.27.0"]

[dependency-groups]
dev = ["ruff>=0.4.0", "pytest>=8.0"]
```

**When TOML:** The primary reader is a build tool, package manager, or
application runtime. Examples: `pyproject.toml` (uv/pip), `Cargo.toml` (cargo),
`config.toml` (application settings).

**The discipline:** One TOML file per concern. `pyproject.toml` owns Python
packaging. A separate `config.toml` owns application settings. Merging unrelated
concerns into one file creates a false single source of truth.

### YAML: Registries and Structured Data

YAML serves cross-referenced data that humans maintain and scripts query.

```yaml
# mani.yaml -- project registry (source of truth for existence)
projects:
  geordi:
    path: geordi
    desc: Unified API and GUI for the agent ecosystem
    tags: [type:application, lang:python, status:active]
```

**When YAML:** The data has relationships (references between entries), supports
programmatic queries, and benefits from comments. Examples: `mani.yaml` (project
registry), `metadata.yaml` (project enrichment), `clusters.yaml` (pipeline
choreography).

**The discipline:** YAML files are registries, not config. A registry declares
what exists and how things relate. If the file controls runtime behavior
(feature flags, thresholds), it belongs in TOML.

### JSON: Tool-Generated Config

JSON serves machine-written settings that machines read.

```json
{
  "hooks": {
    "SessionStart": [
      { "matcher": "", "hooks": [{ "type": "command", "command": "..." }] }
    ]
  },
  "permissions": { "deny": ["Read(./.entire/metadata/***)"] }
}
```

**When JSON:** A tool writes the file, a tool reads it, and humans rarely edit
it. Examples: `.claude/settings.json`, `.flow/state.json`, `package-lock.json`,
`tsconfig.json`.

**The discipline:** Never hand-author JSON for data that has comments or
cross-references. JSON lacks comments. If humans maintain it regularly, YAML or
TOML is the better fit. Accept JSON when the tool mandates it (TypeScript
toolchain, Claude Code settings).

### Environment Variables: Deployment Overrides

Environment variables serve values that change between machines or deployments.

```bash
# Derive paths from script location -- override only at boundaries
LORE_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
WORKSPACE_ROOT="$(dirname "$LORE_ROOT")"
MANI_FILE="${MANI_FILE:-$WORKSPACE_ROOT/mani.yaml}"
```

**When env vars:** The value differs per machine, per environment, or per CI
run. The script provides a sensible default; the variable overrides it.

**The discipline:** Every env var has a default. A script that crashes without
`export FOO=bar` has pushed config into the caller's head. Use `${VAR:-default}`
so the common case works without setup.

### Makefile: Build Entry Points

Makefiles serve as the discoverable command surface for a project.

```makefile
.PHONY: install dev run check test clean

install: ## Install dependencies
    uv sync

dev: install ## Start server with auto-reload
    uv run python server.py

check: install ## Lint and type-check
    uv run ruff check server.py

help: ## Show this help
    @grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
        awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'
```

**When Makefile:** The project needs a standard set of verbs (`install`, `dev`,
`check`, `test`, `clean`). Developers type `make dev`, not
`uv run python server.py --reload --port 8420`.

**The discipline:** Targets are thin wrappers. A `make dev` target that contains
40 lines of shell has become a build script hiding in a Makefile. Extract
complex logic into `scripts/` and call it from the target.

## The yqj Bridge Pattern

Go yq parses YAML. jq transforms JSON. The `yqj` helper bridges them in one
call:

```bash
yqj() {
    yq -o=json '.' "$2" 2>/dev/null | jq -r "$1"
}

# Usage: yqj <jq-expression> <yaml-file>
yqj '.projects | keys[]' "$MANI_FILE"
yqj ".metadata.\"${project}\".role // empty" "$METADATA_FILE"
```

**Why not yq alone?** Go yq and jq have different expression syntax. jq's
language is richer for filtering, joining, and conditional logic. The bridge
lets all query logic use jq syntax while reading YAML natively.

**Why not python-yq?** python-yq wraps jq but uses incompatible flags. Go yq is
the installed version (`/opt/homebrew/bin/yq` v4.52+). Mixing the two produces
silent wrong output.

## Validation

Validate at system boundaries. Trust internal formats.

| Boundary              | Validation                                  | Example                              |
| --------------------- | ------------------------------------------- | ------------------------------------ |
| User input            | Schema check before processing              | `lore validate` checks mani.yaml     |
| External tool output  | Verify expected structure before consuming  | Check jq exit code after yqj call    |
| Cross-project handoff | Contract adherence at the interface         | SIGNAL_CONTRACT fields in state.json |
| Internal reads        | Trust the format; the writer already checks | Scripts trust metadata.yaml shape    |

**The discipline:** Do not re-validate data that an upstream component already
validated. If `lore validate` confirms mani.yaml structure, scripts querying
mani.yaml trust the result. Double-checking creates false safety and real
complexity.

## Used In

| Project | Config Pattern                                                             |
| ------- | -------------------------------------------------------------------------- |
| Lore    | YAML registries and goal/mission definitions, env vars with defaults, Make |
| Geordi  | pyproject.toml (uv), Makefile verbs, .claude/settings.json                 |
| Council | Makefile verbs, .vale.ini, .markdownlint.json, package.json                |

## Common Traps

| Trap                     | Pattern                                          | Fix                                                       |
| ------------------------ | ------------------------------------------------ | --------------------------------------------------------- |
| **Format envy**          | Hand-authoring JSON because "everything is JSON" | Match format to consumer: TOML for humans, JSON for tools |
| **Missing defaults**     | Script requires env var with no fallback         | `${VAR:-default}` for every env var                       |
| **Registry as config**   | YAML file controlling runtime feature flags      | YAML for what exists; TOML for how it behaves             |
| **Makefile as script**   | 40-line shell block inside a Make target         | Extract to `scripts/`; target calls the script            |
| **yq dialect confusion** | Mixing Go yq expressions with python-yq flags    | Use yqj bridge; all logic in jq syntax                    |
| **Validating twice**     | Re-checking structure that the writer guarantees | Validate at boundaries, trust internally                  |
| **Config as docs**       | Comments in config replace actual documentation  | Config declares; docs explain why                         |

## Questions to Ask

### When Designing

- Which tool reads this config, and does the format match that tool's native
  parser?
- Does every environment variable have a default that works for local
  development?
- Can a new developer run `make dev` without reading a setup guide?
- Is each config file scoped to one concern, or has it accumulated unrelated
  settings?

### When Inheriting

- Where do secrets live, and are they separated from checked-in config?
- Which YAML files are registries (declare what exists) vs config (control
  behavior)?
- Does the project use Go yq or python-yq, and are scripts consistent?
- Are Makefile targets thin wrappers, or do they contain embedded build logic?

### Periodically

- Has a JSON file accumulated enough human edits to warrant migration to YAML or
  TOML?
- Are env var defaults still accurate, or have they drifted from actual
  deployments?
- Do new projects follow the format assignments, or has convention eroded?
- Is the yqj bridge still the right seam, or has a tool consolidated YAML and
  JSON querying?

---

_"A place for everything, and everything in its place."_ -- Samuel Smiles
