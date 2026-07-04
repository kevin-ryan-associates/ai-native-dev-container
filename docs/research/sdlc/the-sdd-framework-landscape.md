# The SDD Framework Landscape

Spec-driven development has no single canonical implementation. A dozen frameworks have emerged, each optimized for different team structures, risk profiles, and deployment contexts. Understanding the landscape prevents over-engineering and helps you pick the right tool.

## The Core Spectrum

All SDD frameworks solve the same problem—AI agents need precise specifications to generate reliable code—but they differ in philosophy, complexity, and scope.

**Lightweight & Portable** (5-minute setup, works with any agent)
- OpenSpec
- Superpowers (Obra)
- GitHub Spec Kit

**Heavy & Orchestrated** (enterprise process multipliers)
- BMAD
- Agile V

**Specialized** (solving specific problems)
- Constitutional SDD (security)
- Tessl (spec-as-source)
- Kiro (IDE-native)

---

## The Major Frameworks

### OpenSpec
Lightweight, brownfield-first, agent-agnostic. Specs live in your repo. Works with 20+ agents.

**Philosophy**: <cite index="27-1">Fluid not rigid, iterative not waterfall, easy not complex, brownfield-first—you can create artifacts in any order that makes sense, learn as you build, and specify changes to existing behavior rather than describe entire new systems.</cite>

**Key feature**: Delta specs. Instead of rewriting the entire specification, you mark sections as "ADDED," "MODIFIED," "REMOVED." This keeps diffs manageable when modifying existing systems.

**Best for**: Solo developers, small teams, evolving existing codebases, no vendor lock-in.

**Setup**: 5 minutes (Node.js 20.19.0+). No Python, no dependencies.

---

### GitHub Spec Kit
Thorough, phase-gated, integrated with GitHub. Provides `/specify`, `/plan`, `/tasks` slash commands. Works with 30+ agents.

**Philosophy**: Four-phase workflow (Specify → Plan → Tasks → Implement) with human approval at each gate. Specs are comprehensive Markdown documents.

**Best for**: Teams already in GitHub ecosystem, greenfield projects, organizations that want strict phase discipline.

**Setup**: 30 minutes (requires Python setup).

---

### BMAD (Breakthrough Method for Agile AI-Driven Development)

<cite index="48-1">BMAD is a broader multi-agent orchestration framework that works across domains beyond just software, founded on Agentic Agile Driven Development.</cite>

<cite index="55-1">BMAD simulates an entire agile software team: 12+ specialized AI agents covering Analyst, PM, Architect, UX Designer, Scrum Master, Developer, QA, and Tech Writer roles. Each agent gets a tightly scoped context window and produces a versioned artifact—PRD, architecture document, sprint stories—before the next agent picks up the work.</cite>

**Workflow**: Upstream (Thinking) and Downstream (Building). The Upstream phase has Analyst, PM, and Architect agents collaborate to craft detailed PRDs and architecture docs. Then Downstream agents execute.

**Best for**: Enterprise teams with existing agile processes, audit-heavy environments (SOC 2, compliance), multi-team platform development, consulting deliverables.

**Strengths**:
- Full audit trail from requirement to PR
- Process multiplier for teams already thinking in PRDs and sprint stories
- Traceability is out-of-the-box
- v6 recently hit stable with Scale Adaptive workflows and BMAD-CORE engine

**Weaknesses**:
- For a two-person startup, it's over-engineered
- <cite index="54-1">If your organisation can't do domain-driven design properly, it can't benefit from BMAD's specification layer either</cite>
- Steep learning curve

**Status**: 43K+ GitHub stars. v6 stable.

---

### Superpowers (Obra Org)

<cite index="59-1">An agentic skills framework where once the agent teases a spec out of the conversation, it shows it to you in chunks short enough to actually read and digest. After you've signed off on the design, your agent puts together an implementation plan that's clear enough for an enthusiastic junior engineer with poor taste, no judgement, no project context, and an aversion to testing to follow. It emphasizes true red/green TDD, YAGNI, and DRY.</cite>

**Key innovation**: <cite index="58-1">Skills are Markdown files, not platform-specific plugins. Any agent that reads SKILL.md follows the instructions. This makes Superpowers a portable methodology. Team uses Claude Code, colleague prefers Codex CLI—both run the same skills.</cite>

**How subagent-driven development works**: Once you say "go", it launches a process having agents work through each engineering task, inspecting and reviewing their work, and continuing forward. <cite index="59-1">It's not uncommon for your agent to work autonomously for a couple hours at a time without deviating from the plan you put together.</cite>

**Best for**: Enforced TDD, subagent-driven workflows, teams using multiple AI agents, portable methodology across tools.

**Agent support**:
- Claude Code
- Cursor
- Codex CLI
- Gemini CLI
- Windsurf

**Status**: 89K+ GitHub stars. Production-ready.

---

### AWS Kiro

All-in-one IDE (VS Code fork) with SDD built into the interface. Generates three-document specs (requirements.md in EARS notation, design.md, tasks.md). Powered by Claude Sonnet via Amazon Bedrock.

**Best for**: AWS-native teams, unified IDE + agent experience, teams that want tightest possible integration between specs and implementation.

**Trade-off**: Vendor lock-in (Kiro IDE, Bedrock models).

**Pricing**: $20/month.

**Status**: Beta/stable as of mid-2025; specs don't yet auto-sync with code.

---

## Specialized Approaches

### Constitutional Spec-Driven Development

Not a framework per se—a **methodology** for security. <cite index="57-1">Embeds non-negotiable security principles into the specification layer through a Constitution: a versioned, machine-readable document encoding security constraints derived from Common Weakness Enumeration (CWE)/MITRE Top 25 vulnerabilities and regulatory frameworks.</cite>

<cite index="57-1">Constitutional constraints reduce security defects by 73% compared to unconstrained AI generation while maintaining developer velocity.</cite>

**Best for**: Security-critical domains (fintech, healthcare, payments), regulated industries, any codebase where CWE vulnerability classes are non-negotiable.

**Can be layered onto**: OpenSpec, GitHub Spec Kit, BMAD, or any SDD framework.

---

### Tessl: Spec-as-Source

The most radical SDD approach: the spec is the only artifact humans edit. Code is regenerated from it.

**Philosophy**: Specs are source code. Everything else is transient output.

**Status**: Experimental. Least mature. Aspirational.

**Best for**: Organizations that want ultimate specification discipline and are willing to treat code as generated artifacts.

---

### Get Shit Done (GSD)

Meta-prompting system that decomposes projects into phases, spawns parallel sub-agents, and manages context window limits.

**Important caveat**: <cite index="61-1">GSD is *productivity tooling*, not a *process framework*: it optimizes how an AI agent builds code but prescribes neither independent verification (build and test share context), nor regulatory traceability (no requirement-to-test mapping or audit trail), nor human governance gates.</cite>

**Best for**: Rapid prototyping, context management overhead reduction.

---

### Agile V

Compliance-ready framework for AI-augmented engineering.

<cite index="61-1">Where GSD is a *build accelerator*, Agile V is an *engineering process* that ensures artifacts are verifiable, traceable, and structured for audit review.</cite>

**Best for**: Regulated industries, audit-ready delivery, compliance contexts.

---

### PromptX

Mentioned alongside BMAD and Spec Kit in comparative analysis but less documented. Appears prompt engineering-focused. Not recommended as a first choice until more documentation surfaces.

---

## Comparison Matrix

| Framework | Type | Agent-Agnostic | Setup Time | Best For | Maturity | Audit Trail |
|-----------|------|---|---|----------|----------|----------|
| **OpenSpec** | Lightweight SDD | ✅ | 5 min | Brownfield, small teams | Production | Built-in (git) |
| **GitHub Spec Kit** | Phase-gated SDD | ✅ | 30 min | GitHub teams, greenfield | Production | GitHub native |
| **AWS Kiro** | IDE (SDD built-in) | ❌ | Native | AWS-native, unified workflow | Beta | IDE-native |
| **BMAD** | Multi-agent orchestration | ✅ | 1-2 hours | Enterprise, audit-heavy | v6 stable | Full traceability |
| **Superpowers** | Skills methodology | ✅ | 10 min | TDD enforcement, subagents | Production | Skills-based |
| **Tessl** | Spec-as-source | ✅ | Unknown | Ultimate spec discipline | Experimental | Unknown |
| **Constitutional SDD** | Security methodology | ✅ | Varies | Security-critical domains | Research → adoption | CWE mappings |
| **Agile V** | Compliance framework | ✅ | Unknown | Regulated delivery | Research | Audit-ready |

---

## Selection Guide

### Solo Developer or Small Team (< 5 people)

**Use OpenSpec.**

Lightweight, five-minute setup, no lock-in. You can evolve to something heavier later if you outgrow it. OpenSpec's delta specs are perfect for the "I keep modifying this" workflow.

### Team in GitHub Ecosystem

**Use GitHub Spec Kit.**

Native integration, slash commands, straightforward phase workflow. If you're already using GitHub, no reason to introduce new tools.

### Enterprise, Multi-Team, Audit-Required

**Use BMAD.**

You need the 12+ agent orchestration, versioned artifacts, and full traceability. The overhead is a feature, not a bug. Budget 1-2 weeks for team training.

Pair with Constitutional SDD if you have security-critical domains.

### Strong TDD Culture

**Use Superpowers.**

Enforces true red/green TDD by default, subagent-driven development, and works with whatever agent your team prefers. The skills-as-code model is portable across tools.

### AWS-Native Stack

**Use Kiro or Spec Kit + Bedrock.**

Kiro if you want the tightest integration and don't mind the IDE lock-in. Spec Kit + custom Bedrock integration if you want flexibility.

### Security-Critical (Payments, Auth, Healthcare)

**Use [Any framework above] + Constitutional SDD.**

Start with OpenSpec or BMAD depending on team size, then layer in constitutional constraints with CWE mappings. Non-negotiable in regulated domains.

### Rapid Prototyping, Minimal Ceremony

**Use Superpowers or Vibe Coding.**

Superpowers if you want structure without overhead; vibe coding if you just want to move fast and validate ideas.

---

## The Meta-Decision

Don't pick a framework first. Pick your constraints:

1. **Team size & structure**: Solo? Startup? Enterprise?
2. **Existing tools**: GitHub? AWS? No preference?
3. **Risk profile**: Prototype? Production? Regulated?
4. **Process maturity**: Ad-hoc? Agile-structured? Formal?
5. **Agent preference**: Multi-agent orchestration or stick with one tool?

Then map to the framework:

- **Constraints**: Small team + brownfield + no lock-in → OpenSpec
- **Constraints**: Enterprise + audit + multi-team → BMAD
- **Constraints**: Production + TDD + agent-agnostic → Superpowers
- **Constraints**: Security-critical + any framework → Add Constitutional SDD

---

## Practical Note: Frameworks Are Composable

You don't have to pick one. Many teams use:

- **OpenSpec + Superpowers**: Lightweight specs + strict TDD enforcement
- **BMAD + Constitutional SDD**: Multi-agent orchestration with security constraints
- **GitHub Spec Kit + Superpowers**: Phase discipline + skills-driven implementation

The frameworks are tools in a toolbox. Pick what solves your actual problem.

---

## Looking Ahead

The SDD landscape is still consolidating. By 2027, expect:

- **Convergence**: The core ideas (specs → plan → tasks → code) have converged; differentiation is in tooling
- **IDE integration**: More frameworks will bake SDD into editors (Kiro paved the way)
- **Security-first**: Constitutional constraints will be expected, not specialized
- **Cross-framework interop**: Better ability to move specs between tools (reduce lock-in)
- **Domain specialization**: Frameworks tailored to specific domains (fintech, biotech, etc.)

For now: **pick pragmatically, start small, add discipline as you scale.**
