.PHONY: all help check format lint prose links links-external ghost-names check-memory status dashboard setup clean test dev build preview publish

all: help

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  test     Run security and ghost names test suites"
	@echo "  check    Run all checks (default)"
	@echo "  format   Format markdown with prettier"
	@echo "  lint     Run markdownlint"
	@echo "  prose    Run vale prose checker"
	@echo "  links    Check internal links with lychee"
	@echo "  links-external  Check cross-repo file references"
	@echo "  ghost-names     Check for archived/renamed project names"
	@echo "  check-memory   Check memory files for ghost names (local only)"
	@echo "  status   Report initiative completion status"
	@echo "  dashboard Show initiative status summary table"
	@echo "  setup    Install git hook, download vale packages"
	@echo "  clean    Remove downloaded vale styles"
	@echo "  dev      Start Astro dev server"
	@echo "  build    Build Astro site"
	@echo "  preview  Preview Astro production build"
	@echo "  publish  Sync framework content to public upstream repo"

# Run security and ghost names test suites
test:
	@echo "Running marshal hook tests..."
	@bash tests/test-marshal-hook.sh
	@echo ""
	@echo "Running ghost names tests..."
	@bash tests/test-ghost-names.sh

# Run all checks
check: format lint prose links links-external ghost-names

# Format markdown files
format:
	prettier --write '**/*.md' --ignore-path .gitignore

# Run markdownlint
lint:
	markdownlint '**/*.md' --ignore .vale --ignore node_modules --ignore plans --ignore dist

# Run vale prose checker
prose:
	vale *.md */*.md

# Check internal links
links:
	lychee --offline '**/*.md' --exclude-path src/content/docs --exclude-path node_modules --exclude-path dist --exclude-path plans

# Initial setup
setup:
	vale sync
	ln -sf ../../hooks/pre-commit .git/hooks/pre-commit
	ln -sf ../../hooks/pre-push .git/hooks/pre-push  # experimental
	@echo "Setup complete. Pre-commit and pre-push hooks installed."

# Report initiative completion status
status:
	@bash scripts/check-initiatives.sh

# Show initiative status summary table
dashboard:
	@bash scripts/check-initiatives.sh --dashboard

# Check cross-repo file references
links-external:
	@bash scripts/check-cross-repo-links.sh

# Check for archived/renamed project names
ghost-names:
	@bash scripts/check-ghost-names.sh

# Check memory files only (local -- skipped in CI)
check-memory:
	@bash scripts/check-ghost-names.sh --memory-only

# Start Astro dev server
dev:
	npm run dev

# Build Astro site
build:
	npm run build

# Preview Astro production build
preview:
	npm run preview

# Sync framework content to public upstream repo
publish:
	@bash scripts/sync-upstream.sh

# Clean generated files
clean:
	rm -rf .vale/styles
