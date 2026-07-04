# Developing the Harness

## The Shift From Using to Building

The previous material established what a harness *is*: the loop around a model, where a large and undercredited share of real-world coding performance actually comes from. This page is about the next step — **developing** the harness. It is the difference between accepting a tool's defaults and deliberately shaping the machine so that a given model performs better, more consistently, and more safely.

Everything here is a lever an engineer can pull without touching the model's weights. Together these levers are why the same model can be excellent in one configuration and mediocre in another, and why harness development is a genuine engineering discipline rather than prompt tinkering.

## A Cleaner Spine: Two Buckets

Harness development divides naturally into two categories, and holding them apart is the single most clarifying way to think about it.

**What the model sees** — the probabilistic side. These levers shape the inputs to the model's reasoning: the context it reads, the tools it is offered, the role it is playing, the model itself, and what it remembers. Get these right and the model makes better decisions.

**What the harness enforces** — the deterministic side. These levers wrap the model in machinery that does not depend on the model's judgement at all: verification that checks its work, hooks that fire automatically, permissions that gate its actions, and context management that runs on rules rather than hope. Get these right and the agent behaves reliably even when the model does not.

The core insight from the previous page carries straight through: **the harness is the deterministic machine built around a probabilistic core.** The two buckets are exactly that machine and that core, seen as things you can build.

---

# Bucket One: What the Model Sees

## Context Engineering

Prompt engineering — crafting a clever instruction — is the small, visible tip of a much larger discipline. The real lever is **context engineering**: deciding everything that enters the model's window on each turn of the loop.

The model can only reason about what is in front of it right now. That context is assembled fresh every iteration, and it includes far more than the user's request:

- the **system prompt**, establishing the agent's role, constraints, and operating rules;
- **project instructions** — the persistent, checked-in files (in the `AGENTS.md` / `CLAUDE.md` style) that carry architecture, conventions, forbidden patterns, and preferences into every session without being repeated;
- the **task** itself;
- the **conversation history** so far;
- and the **tool results** accumulated during the run.

Context engineering is the craft of curating that mix. A window packed with irrelevant files and unpruned history starves the model of room to think and buries the signal it needs; a tightly curated window gives the same model dramatically more to work with. This is not a one-time setup — it is an ongoing, per-turn discipline, and it is arguably the highest-leverage skill in the whole of harness development. It is also what makes quality portable: because context assembly is entirely on the harness side, curating it well is what keeps output steady when the model underneath is swapped.

The practical craft includes writing precise project-instruction files, structuring them so the important rules survive; ordering context so the most relevant material is positioned where the model attends to it most; and being ruthless about what does *not* belong in the window.

## Tooling

Tooling is the set of actions the harness exposes to the model — read, write, search, execute, and beyond — and it is where a great deal of harness quality is won or lost. The design work has three parts, and the second and third are the ones people underrate.

**Which tools to expose.** More is not better. A focused set of well-chosen tools is easier for the model to use correctly than a sprawling one. A narrow, well-described tool ("apply this specific kind of edit") often beats forcing the model to compose the right invocation through a generic shell.

**How the tools are described.** The tool schema and its description are prompt surface. A vague description produces misuse; a precise one produces correct calls. The model chooses tools based on what the descriptions tell it, so tool descriptions are part of context engineering by another name.

**How results are shaped and returned.** This is the most overlooked lever in the entire harness. A tool that dumps ten thousand lines of raw output and a tool that returns the relevant region, annotated with line numbers and trimmed of noise, are identical on paper and worlds apart in practice. The formatting, truncation, and summarisation of tool results before they re-enter the context window is pure harness craft, and it directly determines how well the next turn of the loop goes.

Tooling is also the primary extension point. **MCP (Model Context Protocol) servers** are the portable way to add capability — a database connector, a browser controller, a search backend — such that the same tool works across any MCP-capable harness rather than being welded to one. Bespoke, harness-native tools are more tightly coupled but can be more precisely tuned. Both are legitimate; the trade is portability versus fit.

## Agent Profiles and Sub-Agents

A single, general-purpose agent configuration is rarely optimal for every kind of work. **Agent profiles** are named, specialised configurations — each with its own system prompt, its own tool set, and often its own model — tuned for a particular job.

The natural progression is **delegation to sub-agents**: a planning agent that explores and produces a strategy but cannot edit; an implementation agent with full write and execute access; a review agent that inspects diffs against the project's standards. Each is a profile, and the harness orchestrates the handoffs between them. This does two things at once — it lets each stage run on the right prompt and the right model, and it keeps each agent's context focused on its own job rather than carrying the whole task's history. Specialisation is itself a form of context management.

## Model Selection and Routing

Model selection is not a single global choice; the mature pattern is **per-task routing**. Different steps in an agentic workflow have different needs, and matching the model to the need controls both cost and quality:

- a fast, inexpensive model for mechanical or high-volume steps (simple edits, quick lookups, classification);
- a strong reasoning model for the hard parts (architecture, multi-file refactors, debugging subtle failures);
- and, where throughput matters, a model chosen for parallel execution across many concurrent sub-tasks.

Routing turns the model from a fixed cost into a tuned one: the expensive model is spent only where it changes the outcome. Because the harness talks to all of them through a standard interface, routing is a harness-level decision, and it is one of the clearest places where good harness design directly reduces cost without sacrificing quality on the steps that matter.

## Memory and Persistence

By default, what an agent learns in one session evaporates at the end of it. **Memory** is the harness capability that lets useful state survive: decisions made, context retrieved, facts established, patterns learned.

There are layers to it. The simplest and most robust is the checked-in project-instruction file — durable, version-controlled, human-readable memory. Above that sit retrieval mechanisms and dedicated agent-memory frameworks that store and recall prior context across sessions. Memory is powerful but not free: stale or noisy memory pollutes context just as surely as an unpruned window, so what is worth remembering — and what should be allowed to expire — is itself a design decision. This is an actively evolving area, and the right amount of persistence is very much a matter of judgement rather than a solved problem.

---

# Bucket Two: What the Harness Enforces

## Verification and the Feedback Loop

The property that most separates a capable agent from a superficial one is whether it **checks its own work** — and that checking is harness logic, not model intelligence.

A bare agent proposes an edit and moves on. A harness with a closed feedback loop runs the tests after the edit, invokes the linter and the type-checker, attempts the build, and feeds the results back into the loop. Now the model is reacting to ground truth — an actual failing test, a real compiler error — rather than to its own guess about whether the change worked. This is the mechanism that lets an agent make a change, see it break something, and fix it, which is the behaviour that makes agents feel genuinely capable.

Designing this loop is real harness work: which checks run, when they run, how their output is formatted back into context (a wall of stack-trace noise is worse than a focused error), and how many correction cycles are allowed before the harness stops and escalates. Verification is where a large part of practical quality is manufactured, and it is entirely deterministic — the harness decides to run the tests; it does not ask the model to remember to.

## Hooks and Lifecycle Events

**Hooks** are deterministic actions fired at defined points in the loop — before an edit, after a commit, on session start, before a tool runs. They are the non-probabilistic complement to prompting: instead of *asking* the model to remember to format the code, run the tests, or avoid a forbidden pattern, the harness *enforces* it mechanically.

This matters because a probabilistic model will, sometimes, forget or ignore an instruction no matter how firmly it is phrased. A hook does not forget. Anything that must always happen — formatting on every edit, a test run before every commit, a guard that blocks writes to protected paths — belongs in a hook rather than in a prompt. The design skill is knowing which requirements are important enough to move from the fallible probabilistic layer into the reliable deterministic one.

## Permissions and Guardrails

**Permissions** govern what the agent is allowed to do without a human in the loop, and getting them right is what makes an agent trustworthy enough to run unsupervised.

The levers here include approval modes — a **plan** phase that can read and propose but not act, versus an **act** phase that can execute — and fine-grained gating of individual capabilities: which commands run automatically, which require confirmation, which paths are writable, whether network access is allowed, and whether execution is sandboxed. This is simultaneously a safety concern and a trust concern. Too restrictive and the agent constantly interrupts for permission, defeating the point; too permissive and it can do real damage on a bad turn. The right guardrails are calibrated to the blast radius of the work — tighter on production, looser on a throwaway branch — and that calibration is a deliberate harness-design decision, not a default to accept blindly.

## Context Management Mechanics

Context engineering (bucket one) decides what *should* be in the window. **Context management** (bucket two) is the deterministic machinery that keeps the window viable as the run grows longer — and it runs on rules, not on the model's discretion.

Every long-running agent eventually approaches the limit of its context window. What happens then is pure harness logic: **compaction** (summarising earlier turns to reclaim space), **truncation** (dropping the least relevant history), **summarisation** of tool outputs before they land, and decisions about what must be preserved verbatim versus what can be compressed. Done well, a task can run far longer than the raw window would allow while keeping the model oriented. Done badly, the agent loses the thread — forgetting a decision it made earlier, or discarding the very file it still needs. This is one of the hardest parts of harness engineering precisely because it must be automatic and rule-driven, and it is a major reason two harnesses running the identical model diverge on long tasks.

---

# The Supporting Disciplines

Two further practices are not levers on the loop itself but are what make developing the loop tractable rather than guesswork.

## Evaluation

Without evaluation, "harness development" is vibes. Every change described above — a reworded system prompt, a reshaped tool output, a new routing rule, a different compaction strategy — is a hypothesis that it improves the agent, and hypotheses need testing. Evaluation is the discipline of measuring whether a harness change actually helped: a repeatable set of representative tasks, a consistent way of scoring outcomes, and the habit of comparing before and after rather than trusting a single impressive run. It does not have to be elaborate to be worthwhile; even a small, stable task suite turns harness tuning from anecdote into engineering.

## Observability

You cannot improve what you cannot see. **Observability** is the instrumentation of the loop: logging each prompt and response, tracing every tool call and its result, accounting for token usage and cost per step, and recording where time goes. When an agent misbehaves, observability is what lets you locate the failure — was it bad context, a malformed tool result, a wrong model choice, a missing guardrail — rather than guessing. It is also how the leaks in the model-swapping abstraction become visible: without token accounting and tracing, cost blowups and tool-calling failures stay invisible until they hurt.

---

# In Short

Developing the harness means working two sides at once. **What the model sees** — context engineering, tooling, agent profiles, model routing, and memory — shapes the inputs to a probabilistic reasoner so it makes better decisions. **What the harness enforces** — verification, hooks, permissions, and context-management mechanics — wraps that reasoner in deterministic machinery so the agent behaves reliably regardless of the model's judgement on any given turn. Around both sit evaluation and observability, which turn the whole activity from guesswork into engineering.

This is the substance behind the claim that the harness is where the gains are. None of it touches the model's weights, and all of it changes what the model can actually accomplish. Mastering these levers — knowing which one a given problem calls for, and which side of the probabilistic/deterministic line it lives on — is what harness development, and by extension AI-native software engineering, actually consists of.
