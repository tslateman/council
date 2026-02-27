#!/usr/bin/env bash
# Copy framework content into Starlight's content directory.
# Source directories stay untouched -- agents reference them by original path.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DOCS="$ROOT/src/content/docs"

rm -rf "$DOCS"
mkdir -p "$DOCS"

# Landing page (permanent, lives in src/)
cp "$ROOT/src/landing.md" "$DOCS/index.md"

# Seat directories (framework content)
for seat in critic mentor wayfinder marshal mainstay ambassador; do
  mkdir -p "$DOCS/$seat"
  cp "$ROOT/$seat/"*.md "$DOCS/$seat/"
done

# Remove files not intended for public site
rm -f "$DOCS/critic/career.md"

# Getting started
mkdir -p "$DOCS/getting-started"
cp "$ROOT/docs/getting-started.md" "$DOCS/getting-started/index.md"
cp "$ROOT/charter.md" "$DOCS/getting-started/charter.md"

# Guides
mkdir -p "$DOCS/guides"
cp "$ROOT/docs/executive-briefing.md" "$DOCS/guides/"
cp "$ROOT/docs/five-levels-of-ai-coding.md" "$DOCS/guides/"
cp "$ROOT/docs/the-subtraction-test.md" "$DOCS/guides/"
cp "$ROOT/docs/specification-bottleneck-pitch.md" "$DOCS/guides/"
cp "$ROOT/docs/measuring-what-matters.md" "$DOCS/guides/"

# Decision records
mkdir -p "$DOCS/decisions"
cp "$ROOT/docs/adr/"*.md "$DOCS/decisions/"

# Add frontmatter to every file that lacks it
for f in "$DOCS"/**/*.md; do
  if ! head -1 "$f" | grep -q "^---$"; then
    title=$(head -1 "$f" | sed 's/^# //')
    rest=$(tail -n +2 "$f")
    rest=$(echo "$rest" | awk 'NR==1 && /^$/{next} {print}')
    printf '%s\n' "---" "title: \"$title\"" "---" "" "$rest" > "$f.tmp" \
      && mv "$f.tmp" "$f"
  fi
done

echo "Copied $(find "$DOCS" -name '*.md' | wc -l | tr -d ' ') files into $DOCS"
