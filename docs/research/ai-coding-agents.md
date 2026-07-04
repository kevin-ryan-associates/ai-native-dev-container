# AI Coding Agents: A Reference Landscape

## Scope

This page surveys the AI coding agent category as reference material. It is organised around two durable axes rather than benchmark scores, which change month to month: whether a tool is **open source or proprietary**, and whether it is **model-agnostic or locked to a single provider**. Those two properties determine whether a given tool can operate inside a controlled boundary, which is the question that matters most for any sovereignty- or compliance-sensitive deployment.

## The Framing: Harness and Model Are Separable

Every tool in this category is a **harness around a model**. The harness is the execution loop — it reads files, runs shell commands, edits code, inspects output, and repeats. The model is the intelligence that decides what to do next. These two layers are separable, and separating them is the most useful lens for the whole category:

- The **harness** determines the workflow, the surface (terminal, IDE, or cloud), and whether the tool is tied to one vendor.
- The **model** determines output quality and cost, and can often be swapped underneath a capable harness.

From this follow the two questions that outlast any leaderboard. **Is the harness open source?** — this governs whether it can be self-hosted, audited, and run without a per-seat licence or vendor dependency. **Is it model-agnostic?** — this governs whether inference can be pointed at a model the operator controls, including open-weight models running on owned or sovereign infrastructure. A tool that answers "yes" to both is the only kind that can keep both code and inference inside a boundary the operator controls. Everything else — autocomplete quality, agentic depth, benchmark rank — is real but volatile.

Agents are also increasingly interoperable through open protocols (MCP for tool use, ACP for editor–agent communication), which means the model layer underneath the harness is where most of the cost, output quality, and legal exposure actually concentrates.

## Terminal-First Harnesses

These run in the shell and treat the repository as a workspace. They are the surface best suited to headless CI, remote development, and editor-agnostic workflows.

**OpenCode** — Open source (MIT), community-maintained, model-agnostic by design. It routes to a large range of providers and runs whatever endpoint or key is supplied, including local or self-hosted inference via Ollama or a private inference server. It is the most-starred open-source agent in the category. Because the harness is open and the model layer is fully pluggable, it is among the few tools that can be pointed entirely at controlled infrastructure. One operational note: some model vendors restrict third-party harness access — Anthropic, for example, prohibits routing a Claude consumer subscription through third-party tools and briefly blocked OpenCode's Claude API access in early 2026 — so provider terms should be checked when selecting a backend.

**Aider** — Open source (Apache 2.0), model-agnostic (bring-your-own-key), terminal-first. Its distinguishing trait is git-native discipline: every edit is automatically committed with a descriptive message, producing a clean audit trail and trivial rollback. It runs a strong lint-and-test loop after each change and favours surgical, reviewable, file-level edits over full autonomy. The natural open-source counterpart to OpenCode for teams that want tight version-control hygiene.

**Goose** — Open source (Apache 2.0), model-agnostic, now governed under the Linux Foundation (originally from Block). Neutral-foundation stewardship is itself a governance signal worth weighing, since it reduces single-vendor control over the project's direction.

**OpenAI Codex CLI** — Open-source harness (Apache 2.0), but effectively OpenAI-model-centric in practice. Frequently a benchmark leader. The harness is open, but the model gravity pulls toward a single provider.

**Gemini CLI / Antigravity** — Google's open-source CLI harness (Apache 2.0), Gemini-centric in the same way Codex CLI is OpenAI-centric. Antigravity is the evolution of the earlier Gemini CLI line and adds visual parallel-agent management.

**Kilo Code** — Open source (MIT), model-agnostic. A lighter-weight entry in the open terminal-harness tier, in the same family as OpenCode and Aider.

**Claude Code** — Proprietary, and locked to the Claude model family. Terminal-first, but also available in VS Code and JetBrains, a desktop app, and the web. It is among the strongest runtimes for deep, long-running agentic work, with persistent project instructions carried across sessions, hooks for enforcing lint/test/format rules, parallel sub-agents, MCP-native tool use, and a Skills system. The trade is the inverse of the open harnesses: the most polished agentic runtime and a top-tier model, but no model flexibility and no path to keep inference inside a controlled boundary.

## IDE-Native Tools

These integrate directly into an editor, weaving completion, chat, and agent behaviour into the writing surface.

**Cline** — Open source (Apache 2.0), a VS Code extension rather than a CLI. Model-agnostic across many providers plus local models via Ollama and LM Studio. It exposes explicit Plan and Act modes that require approval before each change. It occupies the "open-source, model-agnostic, IDE-native" slot that the proprietary IDE tools do not.

**Roo Code** — Open source, a community fork of Cline offering an alternative feature direction in the same IDE-extension niche.

**Continue** — Historically an open-source (Apache 2.0) IDE extension for completion and chat; its ownership moved under Anysphere (Cursor's maker), so its independent status has changed. Noted for completeness and for teams tracking consolidation in the space.

**Cursor** — Proprietary AI IDE (a fork of VS Code) that largely defines the in-editor experience, with best-in-class inline editing and a supervised agent mode. Multi-model, but a hosted product that is not self-hostable. The reference point for the IDE-native surface.

**Windsurf** — Proprietary AI IDE with positioning similar to Cursor; multi-model, hosted.

**GitHub Copilot** — Proprietary, IDE-first, from GitHub (Microsoft). It began as inline autocomplete and has since added agentic features; it is multi-model on paid tiers (Claude, GPT, and Gemini options). The natural fit for teams already inside VS Code and the GitHub ecosystem, but as a Microsoft-owned SaaS product with server-side processing it sits at the opposite end of the sovereignty spectrum from the open harnesses. Its commercial model shifted to usage-based AI credits in mid-2026.

**Zed** — The editor itself is open source (GPL/AGPL family) and ships native agentic features with ACP support. Relevant where the editor and the agent surface are intentionally the same tool rather than an editor plus a bolted-on extension.

## Cloud and Autonomous Agents

These take a task description and return a result — a pull request or a running application — with minimal supervision.

**Devin** — Proprietary autonomous cloud agent. The reference point for hands-off, hosted "give it a ticket, get a PR" execution.

**Replit Agent** — Proprietary, browser-first, oriented toward rapid prototyping and hosted execution rather than integration into an existing local repository.

## Spec-Driven and Adjacent

**Amazon Kiro** — A spec-driven agentic tool, relevant where specification-first development (writing the spec, then generating against it) is the intended workflow rather than free-form prompting.

**Visual workspaces** (e.g. Nimbalyst, Conductor, Vibe Kanban, Crystal) sit *above* one or more agents rather than being agents themselves. They manage session sprawl, parallel worktrees, planning documents, and diff review when several agent sessions run at once. They are a distinct layer worth knowing about but are not coding agents in the sense used here.

## At a Glance

| Tool | Open source? | Model-agnostic? | Surface | Maintainer |
|---|---|---|---|---|
| OpenCode | Yes (MIT) | Yes (incl. local) | Terminal | Community |
| Aider | Yes (Apache 2.0) | Yes (incl. local) | Terminal | Community |
| Goose | Yes (Apache 2.0) | Yes | Terminal / desktop | Linux Foundation |
| Codex CLI | Yes (Apache 2.0) | OpenAI-centric | Terminal | OpenAI |
| Gemini CLI / Antigravity | Yes (Apache 2.0) | Gemini-centric | Terminal | Google |
| Kilo Code | Yes (MIT) | Yes | Terminal | Community |
| Claude Code | No | No (Claude only) | Terminal + IDE + desktop + web | Anthropic |
| Cline | Yes (Apache 2.0) | Yes (incl. local) | IDE (VS Code) | Community |
| Roo Code | Yes | Yes | IDE (VS Code) | Community |
| Continue | Yes (Apache 2.0)* | Yes | IDE | Anysphere |
| Cursor | No | Multi-model | IDE | Anysphere |
| Windsurf | No | Multi-model | IDE | — |
| GitHub Copilot | No | Multi-model (paid) | IDE-first | GitHub / Microsoft |
| Zed | Yes (GPL/AGPL) | Yes | IDE / editor | Zed Industries |
| Devin | No | — | Cloud | Cognition |
| Replit Agent | No | — | Cloud / browser | Replit |
| Amazon Kiro | No | — | IDE / spec-driven | Amazon |

\* Continue's ownership has moved under Anysphere; its independent open-source status is in transition.

## Selecting Along the Axes

The right choice starts from the binding constraint, not the benchmark:

- **Where inference must remain inside a controlled boundary**, the field narrows to open-source, model-agnostic harnesses that support local or self-routed models — OpenCode, Aider, Cline, Goose, and Kilo Code. This is the only group in which the harness carries no vendor dependency *and* the model can run on owned or sovereign infrastructure. It is the tooling-layer expression of the broader open-source-and-open-weights position: an open harness paired with an open-weight model keeps both the code and the inference within the operator's perimeter, and stays sound regardless of any single vendor changing its terms.
- **Where raw agentic capability on hard, long-running tasks is the priority** and sovereignty is not a hard constraint, Claude Code is among the strongest runtimes; the OpenAI and Google CLIs are the equivalents in their respective model ecosystems.
- **Where the team works primarily inside an editor**, Cursor or Windsurf offer the most polished IDE experience, Copilot fits GitHub-native teams, and Cline (or Zed) provides the open-source, model-agnostic alternative on that same surface.
- **Where work should run unsupervised end to end**, the cloud agents (Devin, Replit Agent) target that pattern directly.

In practice, most teams run two or three: a heavy agentic harness for large changes, an inline tool for in-editor flow, and one open-source, model-agnostic agent for flexibility and for any work that cannot be sent to a third party. Because the harnesses are converging on shared protocols, the harness is best chosen for workflow and openness, and the model for capability and jurisdiction.
