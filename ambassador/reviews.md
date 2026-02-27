# Reviews

Every external artifact is a first impression. Most projects get one.

## What Ambassador Review Is / Isn't

| Ambassador Review Is                              | Ambassador Review Isn't                        |
| ------------------------------------------------- | ---------------------------------------------- |
| Evaluating how outsiders experience the artifact  | Checking whether the code works                |
| Testing whether context survives the boundary     | Verifying test coverage or type safety         |
| Ensuring naming tells the right story             | Enforcing style guide compliance               |
| Asking "would a stranger understand this?"        | Asking "does this follow our internal idioms?" |
| Protecting the project's reputation at the seam   | Reviewing implementation details               |
| Reading the artifact as someone who lacks context | Reading the artifact as someone who wrote it   |

**The test:** A code reviewer asks "does this work?" An Ambassador reviewer asks
"does this land?"

## The Boundary Problem

Internal work carries implicit context. The team knows the history, the
trade-offs, the constraints. External artifacts cross a boundary where that
context vanishes. A PR description that says "fixes the issue" means something
to the author and nothing to the reviewer. An API that exposes `handleLegacyV2`
means something to the team and something worse to the consumer.

The Ambassador's job is to stand at the boundary and read from the outside in.

## PR Surface Review

A pull request speaks to three audiences: the reviewer who merges it, the
engineer who finds it six months later, and the future contributor who uses it
as a template.

### Title

| Signal          | What to Check                                             |
| --------------- | --------------------------------------------------------- |
| **Clarity**     | Does the title convey the change without opening it?      |
| **Specificity** | "Fix bug" fails. "Fix race condition in reconnect" works. |
| **Scope**       | Does the title match the actual diff?                     |
| **Verb choice** | Active voice, imperative mood: Add, Fix, Remove, Update   |
| **Length**      | Under 70 characters. Truncation hides intent.             |

**The discipline:** If you cannot write a clear title, the PR probably does too
many things.

### Description

| Element             | Purpose                                                 |
| ------------------- | ------------------------------------------------------- |
| **Summary**         | One to three sentences: what changed and why            |
| **Motivation**      | The problem this solves, not the solution it implements |
| **Context**         | Links to issues, prior discussion, or relevant docs     |
| **Scope boundary**  | What this PR deliberately excludes                      |
| **Testing**         | How the author verified correctness                     |
| **Migration notes** | Breaking changes, required steps, deployment order      |

**The trap:** Descriptions that restate the diff. "Added a function called
`processQueue`" tells the reader nothing the file list did not already say. The
description exists to carry what the diff cannot: intent, trade-offs, and
context.

### Commit History

| Pattern                   | What It Signals                                |
| ------------------------- | ---------------------------------------------- |
| Clean, logical commits    | The author respects the reader's time          |
| "WIP" and "fix fix fix"   | The author shipped a draft                     |
| One massive commit        | The change resists understanding               |
| Commits that tell a story | A reader can follow the reasoning step by step |

Commit history is documentation. Treat it that way.

## API Surface Review

An API is a promise. Every public endpoint, parameter name, and error message
becomes a contract the moment someone depends on it.

### Naming

| Principle           | Application                                           |
| ------------------- | ----------------------------------------------------- |
| **Consistency**     | Follow established patterns in the existing API       |
| **Domain language** | Use terms the consumer knows, not internal jargon     |
| **Predictability**  | If `getUser` exists, `getTeam` follows the same shape |
| **Honesty**         | The name should describe what the thing does, fully   |
| **Stability**       | Names are harder to change than implementations       |

**The test:** Could a consumer guess the endpoint name and parameters without
reading documentation? Consumers discover the best APIs without reading docs.

### Error Surface

| Quality              | What It Means                                              |
| -------------------- | ---------------------------------------------------------- |
| **Actionable**       | The consumer knows what to do next                         |
| **Specific**         | "Invalid request" fails. "Field 'email' required" works.   |
| **Consistent codes** | Same problem returns same status code everywhere           |
| **Safe**             | Errors never leak internal paths, stack traces, or secrets |
| **Documented**       | Documentation covers every error a consumer can encounter  |

Errors are the API's voice under stress. A consumer who hits an error is already
frustrated. The error message either rebuilds trust or destroys it.

### Versioning and Change

| Question                                     | Why It Matters                                |
| -------------------------------------------- | --------------------------------------------- |
| Does this change break existing consumers?   | Breaking changes cost trust, not just time    |
| Is the deprecation path clear?               | Consumers need time and instructions          |
| Are new fields additive, not transformative? | Additive changes preserve backward compat     |
| Is the version strategy explicit?            | Implicit versioning creates implicit breakage |

## Documentation Tone

External documentation carries the project's voice. The reader forms an opinion
of the entire project from the first paragraph.

### Voice Principles

| Principle      | Application                                             |
| -------------- | ------------------------------------------------------- |
| **Direct**     | Say what the thing does. Skip "basically" and "simply." |
| **Honest**     | State limitations. "Does not support X" beats silence.  |
| **Respectful** | Assume competence. Avoid "just do X" and "obviously."   |
| **Concrete**   | Show the example first, explain second.                 |
| **Consistent** | Same terminology throughout. A glossary prevents drift. |

**The trap:** Documentation written for the author instead of the reader.
Internal shorthand, assumed context, and missing prerequisites create a wall
that looks like a welcome mat.

### README as Storefront

| Section           | The Question It Answers                         |
| ----------------- | ----------------------------------------------- |
| **Opening line**  | What is this and why should I care?             |
| **Quick start**   | How do I get from zero to working in 5 minutes? |
| **Examples**      | What does real usage look like?                 |
| **API reference** | Where are the details when I need them?         |
| **Contributing**  | How do I participate?                           |

The README is the most-read file in any repository. Invest accordingly.

## Changelog Review

A changelog speaks to existing users. They need to know what changed, what
broke, and what to do about it.

| Quality            | Test                                                  |
| ------------------ | ----------------------------------------------------- |
| **Completeness**   | Does every user-visible change appear?                |
| **Categorization** | Are additions, fixes, and breaking changes separated? |
| **Migration path** | Does every breaking change include upgrade steps?     |
| **Tone**           | Written for users, not developers?                    |

**The discipline:** "Internal refactoring" is not a changelog entry. If the user
cannot observe the change, it does not belong here.

## Common Traps

| Trap                      | Pattern                                                     | Fix                                                  |
| ------------------------- | ----------------------------------------------------------- | ---------------------------------------------------- |
| **Internal jargon leak**  | "Fixes the yeoman sync" in a public PR title                | Translate to the reader's vocabulary                 |
| **Missing context**       | PR description assumes knowledge the reviewer lacks         | Write for the person who joins the team next month   |
| **Inconsistent naming**   | `userId` in one endpoint, `user_id` in the next             | Audit naming before shipping new surface area        |
| **Optimistic errors**     | API returns 200 with an error buried in the body            | Use HTTP status codes honestly                       |
| **Documentation decay**   | Docs describe the system as it was, not as it is            | Update docs in the same PR that changes behavior     |
| **Scope camouflage**      | PR title says "small fix," diff touches 40 files            | Title and description must match the actual scope    |
| **Template cargo cult**   | PR description fills template fields with placeholder text  | A template is a prompt, not a form to complete       |
| **The insider README**    | Getting started guide requires three tools no one mentioned | Test the README from a clean machine                 |
| **Changelog silence**     | Breaking change ships with no changelog entry               | Breaking changes without migration notes break trust |
| **Premature publication** | API ships before naming and error patterns stabilize        | Internal consumers first; public consumers after     |

## The Ambassador's Checklist

Not a step-by-step procedure. A set of lenses to apply before any artifact
crosses the boundary.

| Lens               | Core Question                                       |
| ------------------ | --------------------------------------------------- |
| **Stranger test**  | Would someone with no context understand this?      |
| **Search test**    | Will someone find this when they need it?           |
| **Template test**  | Would future contributors copy this as a pattern?   |
| **Trust test**     | Does this build or erode confidence in the project? |
| **Longevity test** | Will this make sense in six months?                 |

## Questions

### Before Publishing

- Who will read this first? What do they know? What are they missing?
- Does every name, term, and abbreviation resolve without insider knowledge?
- If this is the reader's first encounter with the project, what impression does
  it create?
- What context lives in your head that did not make it into the artifact?

### During Review

- Am I reading this as a team member or as a stranger?
- Where does the artifact assume knowledge it has not provided?
- Does the naming tell a coherent story, or does it leak history?
- Are the error messages useful to someone who cannot read the source?

### After Publishing

- Did consumers ask questions the artifact should have answered?
- What patterns did new contributors copy from this artifact?
- Where did naming or documentation drift from what shipped?
- What would we write differently with six months of hindsight?

---

_"No mission succeeds in isolation."_ -- Ambassador's Oath
