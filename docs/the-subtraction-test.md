# The Subtraction Test

Counterpoint to [The Five Levels of AI Coding](five-levels-of-ai-coding.md).
That document measures autonomy. This one asks what autonomy costs.

## -2,000 Lines

Bill Atkinson optimized Apple code and recorded "-2,000 lines" on his
productivity form.[^1] Managers stopped asking him to track lines of code.

Progress in software often means subtraction, not accumulation. AI inverts this.
Code becomes cheap, so organizations optimize for volume. Projects promote
millions of generated lines no one understands.

## Instant Legacy Code

AI-generated code creates "instant legacy code": systems that function until
they break, with no one holding the context to fix them.[^2] The developer who
generated the code never built the mental model that debugging requires. The
cognitive gap between generation and comprehension widens at every level of
autonomy.

The five levels framework treats removing humans from the loop as progress. But
a Level 5 dark factory that generates code no human comprehends is a liability
with a delayed fuse.

## Activity vs. Achievement

Confusing activity with achievement is not a new mistake. AI makes it easier to
commit at scale.[^1] Advanced models still fail at rates that would alarm anyone
measuring outcomes rather than output. Generating vast amounts of code with
advanced technology is a primitive management error dressed in modern tooling.

## The Apollo Precedent

Margaret Hamilton's Apollo software succeeded not because of its volume but
because every line carried cost.[^1] Limited memory and processing power
enforced discipline. Constraint produced reliability.

AI removes that constraint. Nothing forces economy. Specifications must
reintroduce it deliberately: define what to subtract, not just what to build.
Verification must catch bloat, not just bugs.

## The Tension

The five levels and the subtraction test are not contradictory. They are
complementary pressures:

| Five Levels say                    | Subtraction Test says                                           |
| ---------------------------------- | --------------------------------------------------------------- |
| Move toward autonomy               | Autonomy without understanding is fragile                       |
| Specification replaces code review | Specifications must constrain scope, not just describe features |
| Higher levels unlock productivity  | Productivity measured in volume is a trap                       |
| Trust the system                   | Verify the system subtracts, not just adds                      |

Higher levels demand better specifications precisely because no one reads the
code. If the spec is vague, AI fills the gap with volume. Volume without
understanding is activity mistaken for progress.

The corrective is not to stay at Level 2. It is to ensure that every level
transition improves specification quality, not just autonomy.

[^1]:
    [Lines of Code](https://www.youtube.com/watch?v=POMqB6tGB74), on
    AI-generated volume and the Apollo software precedent.

[^2]:
    [CMU, arXiv:2511.02922](https://arxiv.org/html/2511.02922v1). AI assistance
    reduced task time and increased test pass rates, but code comprehension
    remained unchanged. The term "instant legacy code" reflects industry
    consensus across multiple sources.
