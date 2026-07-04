# Agentic Tooling

## What a Tool Is

A model, on its own, produces text. **Tools** are what turn that text into action — they are the mechanism through which an agent reads a file, runs a test, searches a codebase, or queries a service. Every capability an agent has beyond talking is a tool the harness exposed to it.

"Developing the Harness" named tooling as one of the levers of harness quality. This page is the full anatomy of that lever. It covers two distinct questions that the word "tooling" tends to blur together: **where tools come from** — the supply — and **what makes a tool good** — the design. It closes on the two dimensions that cut across both: safety and sovereignty.

The mechanics of the tool call itself were covered in the model-swapping material: the harness advertises a set of tools with their schemas, the model responds with a request to call one, the harness executes it and feeds the result back. This page is about *which* tools to expose and *how* to build them well.

## Where Tools Come From

A harness assembles its tool set from three sources, and the distinction between them matters for portability, capability, and risk.

### Built-in Tools

Every harness ships a core set of tools directly: filesystem access, search, execution, and so on. These are the irreducible primitives — an agent cannot work on code without being able to read and write it — and they are tuned tightly to the harness because they are part of it. The next section catalogues these by category.

### CLI and Shell Access

The single most powerful tool a harness can expose is a generic "run a shell command" tool, and it deserves separate treatment because of what it actually is. A shell tool does not add one capability; it adds *the entire universe of installed command-line programs* as latent tools. The moment an agent can run shell commands, it can use `git`, `grep`, `curl`, `npm`, `docker`, `sed`, and everything else on the system — without any of them being individually defined as tools.

A large fraction of what looks like sophisticated agentic behaviour is exactly this: the model already knows how to drive standard CLI programs, and the shell tool lets it. This is enormous leverage. It is also why the shell tool is the most dangerous single tool in the box — it is unbounded by design, and it is the tool the permission and guardrail machinery from the previous page most needs to constrain. Capability and risk here are the same property viewed from two sides.

### MCP: Portable External Tools

The **Model Context Protocol (MCP)** is the standard interface for supplying tools to a harness from outside it. An MCP server is a separate process — running locally as a subprocess, or remotely over HTTP — that exposes a set of tools; any MCP-capable harness can connect to it and offer those tools to the model.

The significance of MCP is portability, and it is the same argument that runs through the whole section. A tool built as an MCP server — a database connector, a browser controller, an issue-tracker integration, an internal-service client — is written once and works across OpenCode, Claude Code, Cline, and any other MCP client, rather than being welded to one harness. Where the model-swapping standard made *models* interchangeable beneath the harness, MCP makes *tools* interchangeable across harnesses. It is the extensibility path, and the portable one: a capability added via MCP is not a bet on a single tool surviving.

The trade against MCP is the same trade as always: a harness-native tool can be more tightly tuned to that harness, while an MCP tool is more portable. Both are legitimate; the choice is fit versus reach.

## The Categories of Tool

Regardless of source, the tools a coding agent uses fall into recognisable categories. Knowing the categories is what lets you reason about whether an agent has what it needs for a given kind of work.

**Filesystem** — read, write, edit or patch, and list files. The irreducible core; without these the agent cannot touch code at all. The quality of the *edit* tool in particular — whether it applies precise patches or rewrites whole files — has an outsized effect on how cleanly the agent works.

**Search and navigation** — literal search (grep), file-pattern matching (glob), and codebase or semantic search. This is how the model *finds* what it needs before acting, and it is frequently the difference between an agent that operates competently in a large repository and one that flounders in it. An agent that cannot search well cannot orient itself, and an unoriented agent guesses.

**Execution** — running tests, builds, linters, type-checkers, and the code itself. This is the category that closes the feedback loop: it is what lets the agent see the real consequences of a change rather than its own prediction of them. Execution tools are where verification (from the previous page) is actually implemented.

**Version control** — git operations exposed as tools. Beyond the obvious utility, this is part of the safety story: commits function as checkpoints, and the ability to diff and roll back turns version control into a recovery mechanism as much as a capability.

**Network and web** — fetching URLs, web search, calling external APIs. Powerful for research and integration, and — flagged here, developed below — the primary surface through which data can leave the boundary.

**External and integration tools** — databases, browsers, issue trackers, internal services. The open-ended category, delivered mostly through MCP, that connects the agent to systems specific to a project or organisation.

**Delegation** — a harness can expose "hand this off to another agent" as a tool itself, letting a coordinating agent dispatch work to specialised sub-agents. This ties the tool layer back to agent profiles: a sub-agent, from the caller's perspective, is just another tool.

## What Makes a Tool Good

The categories describe *what* tools do. Their quality — whether the same tool helps or hinders the same model — is a separate matter, and it is the part of tooling most often skipped. A well-designed tool and a poorly designed one can occupy the same category and produce completely different agent behaviour.

**Description quality.** A tool's schema and description are prompt surface. The model decides which tool to call, and how, entirely from what the descriptions tell it. A vague description produces misuse; a precise one produces correct calls. Writing tool descriptions is a form of context engineering, and it is easy to underinvest in.

**Result shaping.** This is the single most underrated lever in the whole of tooling. How a tool's output is formatted, truncated, and summarised before it re-enters the context window largely determines how well the next turn of the loop goes. A tool that returns ten thousand lines of raw output and one that returns the relevant region, trimmed and annotated with line numbers, are identical on paper and worlds apart in effect. Good tools return signal; poor tools return noise, and noise both misleads the model and consumes the context budget.

**Granularity.** Narrow, purpose-built tools versus the generic shell is a real design choice. A dedicated `edit_file` tool with a clean schema is easier for the model to use correctly than asking it to compose the right `sed` invocation — but every additional named tool is more surface for the model to choose among. The craft is exposing focused tools for the operations that matter and leaning on the shell for the long tail.

**Error surfaces.** How a tool fails teaches the model how to recover. A tool that returns a clear, actionable error ("file not found: check the path") lets the model correct itself; one that returns a raw stack trace, or nothing, derails it. Designing the failure output is as important as designing the success output, because agents spend a great deal of their time reacting to failures.

**Token economy.** Every tool result spends context budget. A chatty tool is not just wasteful — it is a context-management problem, crowding out the history and code the model needs to hold. Tool design and context management are the same concern seen from two ends.

## The Safety Dimension

Tools are exactly where the permissions and guardrails from "Developing the Harness" apply, because tools are the only way an agent affects anything. Not all tools carry equal risk, and the sound approach gates them according to their blast radius:

- **Read-only tools** (search, read, list) are low risk and can generally run freely.
- **Mutating tools** (write, edit, commit) change state and warrant more care, though version control makes them recoverable.
- **Destructive tools** (delete, force-push, drop) can cause irreversible harm and merit explicit gating or prohibition.
- **Execution and shell tools** are unbounded and are the primary target for approval modes, sandboxing, and allow-listing.

The point is that "tooling" and "safety" are not separate topics. The tool set *is* the attack surface and the risk surface, and calibrating which tools run freely, which require confirmation, and which are forbidden is how an agent is made safe enough to run with less supervision.

## The Sovereignty Dimension

The tooling layer is also where the section's central concern — keeping data and inference inside a controlled boundary — becomes concrete, because tools are where data can *leave* that boundary.

Network and web tools, and remote MCP servers, are egress points. A tool that fetches a URL, calls a third-party API, or connects to a hosted MCP service sends data outward, and that is an inference-and-data-boundary question, not merely a capability question. A remote MCP server processes whatever the agent sends it on infrastructure someone else controls, under whatever jurisdiction that someone sits in — the same analysis applied to models in the sovereignty material, now applied to tools.

The practical implications follow directly. For a sovereignty-sensitive deployment, prefer local MCP servers over remote ones where the choice exists; treat network-egress tools as a boundary crossing to be justified rather than a default; and recognise that adding a tool can quietly widen the boundary just as choosing a hosted model does. An agent is only as sovereign as its most outward-reaching tool.

## In Short

Agentic tooling is how a model acts. Tools come from three sources — built-in primitives, the uniquely powerful and uniquely dangerous shell, and portable external tools via MCP — and fall into recognisable categories: filesystem, search, execution, version control, network, integration, and delegation. Their *source* determines portability and risk; their *design* — description, result shaping, granularity, error surfaces, token economy — determines whether they help or hinder the model that uses them.

Cutting across all of it are two dimensions the rest of the section has been building toward. Tools are the risk surface, so they are where guardrails apply; and tools are the egress surface, so they are where sovereignty is won or lost. Choosing and building tools well is therefore not a convenience feature of a harness — it is a large part of what makes an agent capable, safe, and sovereign at once.
