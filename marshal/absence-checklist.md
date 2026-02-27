# Absence Checklist

Systematic gap detection by domain. For each category, ask: "Is this addressed,
explicitly excluded, or silently missing?"

## Categories

### Error Handling

- What happens when the happy path fails?
- Are all external calls (APIs, databases, filesystem) wrapped?
- Does every error have a recovery strategy or explicit failure mode?
- Are error messages actionable for the person who sees them?

### Rollback

- Can this change be undone?
- What happens to data created during a partial failure?
- Is there a migration path backward, or only forward?
- Are rollback steps documented or automated?

### Security

- Who has access? Who shouldn't?
- Are inputs validated at system boundaries?
- Are secrets hardcoded, environment-bound, or managed?
- What's the blast radius of a compromised credential?

### Monitoring

- How do you know this is working in production?
- What alerts exist? What should alert but doesn't?
- Are success and failure both observable?
- Is there a dashboard, or does someone have to dig?

### Edge Cases

- What happens at zero, one, many, and overflow?
- What happens with empty input, null input, malformed input?
- What happens when two things happen at the same time?
- What happens when a dependency is slow, down, or returning garbage?

### Success Metrics

- How do you know this succeeded?
- Are the metrics measuring the goal or a proxy?
- When will you evaluate?
- What threshold triggers a rethink?

### Failure Modes

- What's the worst-case outcome?
- What's the most likely failure?
- What failure would be the hardest to detect?
- What failure would take the longest to recover from?

### Dependencies

- What does this depend on that it doesn't control?
- Are dependency versions pinned, floating, or unspecified?
- What happens when a dependency changes its API?
- Are there circular dependencies?

### Permissions

- Who can invoke this? Who can modify it?
- Are permissions least-privilege?
- Can a user escalate through this path?
- Are permission changes audited?

### Data Migration

- Does existing data survive this change?
- Is the migration reversible?
- What happens to data created between deploy and rollback?
- Are schema changes backward-compatible?

## Using the Checklist

Scan each category. For every gap found, classify:

| Severity | Meaning                                      |
| -------- | -------------------------------------------- |
| Critical | Will cause failure if unaddressed            |
| High     | Likely to cause problems under real usage    |
| Medium   | Risk exists but is unlikely or low-impact    |
| Low      | Nice to have, not a gap in the current scope |

Report gaps, not confirmations. Silence means "covered."
