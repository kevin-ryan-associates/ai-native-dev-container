# The Harness: What a Coding Agent Really Is

## The Core Idea

A coding agent is not a model. It is a **loop** wrapped around a model — and understanding that loop is the difference between treating these tools as magic and engineering with them deliberately.

The intelligence that writes the code lives in the model. But a model, on its own, can only generate text. It cannot read a file, run a test, see an error, or edit a line. Everything an agent *does* — as opposed to *says* — is the harness's work. The harness is the program that turns a text generator into something that acts on a codebase. It is where consistency is enforced, where speed and quality are held steady across different model providers, and where most of the practical craft of AI-native engineering actually lives.

This page explains what the harness is, what it is made of, why it matters more than its low profile suggests, and why understanding it is a core skill rather than an implementation detail.

## The Loop

Strip away the branding and every coding agent runs the same cycle:

1. The harness assembles a **prompt** and sends it to the model, along with a description of the **tools** the model is allowed to use.
2. The model responds — either with text, or with a request to call a tool (read a file, run a command, apply an edit).
3. The harness **executes** that tool call in the real environment and captures the result.
4. The harness **feeds the result back** into the conversation and returns to step 1.
5. This repeats until the task is done, the model signals completion, or a stopping condition is hit.

That loop is the agent. A model proposes; a tool executes; the result informs the next proposal. Run it once and you have a chatbot that can look something up. Run it in a disciplined cycle with good tools and good context management, and you have something that can navigate a repository, make a multi-file change, run the tests, read the failures, and fix them — because each turn of the loop grounds the next in what actually happened, rather than what the model guessed would happen.

## The Three Components

The loop is built from three parts. Their quality, and the way they fit together, is what separates a capable harness from a frustrating one.

**Prompts.** Not a single clever instruction, but the entire construction of what the model sees each turn: the system prompt that establishes the agent's role and rules, the project-specific instructions, the task, the conversation history, and the tool results so far. The prompt is rebuilt on every iteration of the loop, and how it is built is a design decision with large consequences.

**The model.** The reasoning engine. As covered in the companion material on model-swapping, the model is deliberately kept as a replaceable component behind a standard interface — which is precisely what lets the harness hold everything else constant while the model underneath changes.

**Tooling.** The richest of the three, and the most undervalued. Tooling is the set of actions the harness exposes to the model — read, write, search, execute, and whatever else — but it is more than the list of tools. It is also *how the tool results are shaped and returned*. A file-read tool that returns ten thousand lines of noise and a file-read tool that returns the relevant region with line numbers are the same tool on paper and completely different in practice. Much of what makes one harness outperform another with the identical model is the quality of its tools and the discipline of what those tools hand back.

## The Two Jobs the Harness Does That the Model Cannot

Two responsibilities sit entirely with the harness, and both are where good and bad agents most visibly diverge.

**Context management.** The model can only reason about what is in its context window this turn. Deciding *what goes in* — which files, how much history, how tool outputs are summarised or truncated, what gets dropped when space runs low — is the harness's job, not the model's. This is arguably the single highest-leverage responsibility in the whole system. A harness that fills the window with irrelevant content starves the model of room to think; one that curates context tightly gets far more out of the same model. Because this work is entirely on the harness side, it is also what allows quality to stay consistent when the model provider changes underneath.

**Error recovery and knowing when to stop.** Real work fails constantly: a command errors, a patch does not apply, the model proposes something incoherent, a loop starts spinning without progress. What happens next is pure harness logic — retry, re-plan, compact the context and try again, surface the problem to the human, or stop. A harness with no recovery strategy produces an agent that derails at the first surprise. A harness with good recovery produces one that behaves like it is being supervised even when it is not. The stopping condition matters just as much: an agent that does not know when it is finished, or when it is stuck, is worse than one that stops early and asks.

## Why the Harness Is Where the Gains Are

Here is the point that is easy to overstate, so it is worth stating precisely.

A large and systematically undercredited share of real-world coding-agent performance comes from the harness, not the raw model. The clearest evidence is the **harness effect**: take a single fixed model and run it inside a bare, minimal loop, then inside a well-built harness, and its measured success rate on real engineering tasks jumps substantially — commonly by double-digit percentage points on benchmarks like SWE-bench and Terminal-Bench. The model did not change. Only the loop, the tools, and the context management around it did.

The careful claim is this: **raw model capability and harness quality are multiplicative, not additive, and the harness contribution is routinely misattributed to the model.** When an agent ships a hard refactor cleanly, the headline credits the model name — but a meaningful part of that outcome was the harness feeding the model the right context, exposing the right tools, formatting results usefully, and recovering gracefully when a step failed. The base models genuinely did improve, and that is real. But the lived experience of these tools getting dramatically better over a short period is as much a story of harness engineering maturing as it is of model weights improving. Benchmarks and marketing attribute everything to the model because the model has a name and the harness usually does not.

This is also why the same model can feel excellent in one tool and mediocre in another. The variable is not the intelligence. It is the machine built around it.

## Why This Is a Crucial Skill

If the harness is where a large part of the quality lives, then understanding the harness is not optional knowledge for an AI-native software engineer — it is a core competency, in the way that understanding compilers, version control, or build systems is core.

Concretely, harness literacy is what lets an engineer:

- **Diagnose failures correctly** — distinguishing "the model is not capable enough for this" from "the harness gave the model bad context or bad tools," which are entirely different problems with entirely different fixes.
- **Get more from any given model** — including cheaper or open-weight models, by improving the context, tools, and instructions around them rather than reaching for a bigger model.
- **Maintain quality across providers** — holding output steady while swapping the model underneath for reasons of cost, capability, or jurisdiction, which is only possible if you understand what the harness is keeping constant.
- **Build and customise** — writing project instructions, defining tools, shaping tool outputs, and tuning context strategy, rather than accepting a vendor's defaults as fixed.

The shift is from thinking of these tools as intelligent black boxes to understanding them as engineered loops with parts that can be inspected, chosen, and improved. That shift is what "AI-native" actually means at the engineering level.

## In Short

A coding agent is a loop: a model proposes, tools execute, results feed back, and the cycle repeats under the harness's control. Its three components are prompts, the model, and tooling — and its two defining responsibilities, context management and error recovery, belong to the harness alone. This is where consistency is enforced and where quality and speed are held steady across model providers.

It is also where a large and undercredited share of recent real-world performance gains have come from: not only better model weights, but better machinery built around them. For that reason, understanding the harness — not just the model — is one of the defining skills of AI-native software engineering. The model is the engine. The harness is the car. It is worth knowing how to build the car.
