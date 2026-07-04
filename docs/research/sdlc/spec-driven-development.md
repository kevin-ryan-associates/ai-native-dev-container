# Spec-Driven Development: Current State of the Art

Spec-driven development (SDD) emerged as a foundational practice in 2025 and has matured rapidly. It inverts traditional workflows: specifications become the primary artifact, and code is a generated output constrained and guided by precise, machine-readable specs.

## What is Spec-Driven Development?

SDD is a development paradigm that uses well-crafted software requirement specifications as executable input to AI coding agents, separating the planning phase (understanding requirements, designing constraints, curating prompts) from implementation (generating code against validated plans).

The core principle: specify once, generate consistently. One bad line of specification produces 10,000+ bad lines of code (wrong problem). The highest-leverage work happens before a single line of code is written.

## Why Now?

While specifications have existed for decades, SDD became viable in 2025-2026 for three reasons:

1. **Context windows**: Large language models now support enough context to handle entire specifications alongside code generation
2. **Agent maturity**: AI agents separate planning and implementation phases, preventing premature coding
3. **The productivity paradox**: AI tools boost individual velocity but leave system-level delivery metrics (lead time, deployment frequency, change failure rate) unchanged—the bottleneck is specification clarity, not code writing speed

## The Four Phases

Every major SDD framework converges on the same workflow:

### Phase 1: Specify

**Output**: Detailed functional specification

Answers "What should the software do?" without prescribing implementation.

Covers:
- Objective and scope
- Requirements and acceptance criteria (typically in EARS notation: "WHEN [condition] THE SYSTEM SHALL [behavior]")
- Project structure and code style
- Testing strategy
- Boundaries and non-goals

**Human checkpoint**: Review specification completeness and correctness before proceeding.

### Phase 2: Plan

**Output**: Technical architecture document

Answers "How will we build this?"

Covers:
- Technical approach and architectural patterns
- Technology choices and trade-offs
- Data models, APIs, and interfaces
- Risks, dependencies, and integration points
- Repository-specific considerations (important for brownfield codebases)

**Human checkpoint**: Validate architecture aligns with requirements and constraints.

### Phase 3: Tasks

**Output**: Granular implementation tasks

Breaks the plan into discrete work items.

Each task includes:
- Clear verification criteria
- Explicit dependencies and ordering
- Testing requirements
- Scope small enough for single-shot generation

**Human checkpoint**: Confirm task breakdown is complete and dependencies are correct.

### Phase 4: Implement

**Output**: Production code, tests, documentation

Agents generate code task by task using your existing AI tooling (Claude Code, GitHub Copilot, Cursor, etc.).

Code flows directly to PR review; developers validate focused, testable changes rather than reviewing monolithic code dumps.

## Tooling Ecosystem

### Core Tools

**GitHub Spec Kit** — Open-source, model-agnostic toolkit launching September 2025. Reached 90k+ GitHub stars by mid-2026. Provides `/specify`, `/plan`, `/tasks` commands; works with 30+ agents.

**AWS Kiro** — Agentic IDE launched July 2025. Uses EARS notation, generates three-document specs (requirements.md, design.md, tasks.md). Includes 2026 Requirements Analysis feature using formal logic to catch contradictions before code generation.

**Claude Code Skills** — Package SDD workflows as reusable slash commands. Encode spec templates, conventions, and guardrails once; invoke on demand across projects.

**Cursor Plan Mode** — Native SDD integration via `.cursor/rules` for context governance.

### Spec Notation

**EARS** (Easy Approach to Requirements Syntax) — Five patterns for testable acceptance criteria:
- `WHEN [condition] THE SYSTEM SHALL [behavior]`
- `IF [condition] THEN [action]`
- `WHERE [constraint]`
- `The system SHALL [requirement]`
- `The system SHALL NOT [prohibition]`

EARS is more rigorous than natural language and parseable by agents.

## Context Engineering

Specs are one layer. **Context engineering** — curating the entire information environment an AI agent operates within — determines whether agents ship reliable code or generate technical debt.

This includes:
- Files the agent reads (codebase context, examples)
- Rules it follows (style guides, patterns, constraints)
- History it carries (previous decisions, rationale)
- Tools it can reach (APIs, integrations)
- Project structure navigation

By mid-2025, context engineering was identified as the discipline that makes or breaks agentic code quality.

## Security and Governance

LLMs generate vulnerable code at rates between 9.8% and 42.1% across benchmarks. Production AI-introduced vulnerabilities topped 110,000 by February 2026.

SDD addresses this through:

**Constitutional SDD** — Embedding security constraints alongside specs with explicit CWE vulnerability mappings.

**Spec-anchored governance** — Formal requirements enforcing cross-service coordination, contract validation, and audit trails.

**Approval checkpoints** — Human review before merge, especially for sensitive domains (payments, auth, data handling).

## Static vs. Living Specs

A critical differentiator: static spec documents drift from implementation within hours.

**Living SDD** treats specs as operational infrastructure that coordinates agents across the full SDLC:
- Specs version-controlled alongside code
- Referenced in pull requests for traceability
- Delta specs for incremental updates
- Continuous validation against implementation

Adopting a tool requires asking: are specs static planning documents, or operational assets that evolve with the codebase?

## SDD vs. Related Practices

| Practice | Artifact | Scope |
|----------|----------|-------|
| **TDD** | Failing unit test | Code unit level |
| **BDD** | Behavior in business language (Gherkin) | Feature level |
| **SDD** | Complete spec (behavior + architecture + constraints + tests) | System level |

SDD subsumes parts of TDD and BDD. Most SDD workflows still generate unit and integration tests—they're derived from the spec rather than written first.

## Antipatterns

**Heavy up-front specification with big-bang releases** — Specs drift and become unmanageable over time. Apply SDD incrementally to existing codebases in small, validated slices.

**Context rot** — Large specs overwhelm agent context windows. Keep specs focused and link to external references rather than embedding entire related systems.

**Spec as documentation theater** — Static specs that teams read once and ignore. Treat specs as living assets validated against implementation.

## Adoption Patterns

### Greenfield Projects
Straightforward: Specify → Plan → Tasks → Implement. No architectural debt to navigate.

### Brownfield / Legacy Codebases
Start with a single feature:
1. Reverse-engineer a spec from existing behavior (what the code currently does)
2. Plan modernization approach
3. Execute tasks incrementally
4. Validate against existing test suite before integration

This prevents "automating the creation of legacy mess."

### Distributed Teams / Microservices
SDD scales better than ad-hoc approaches:
- Spec Kit's four-phase workflow coordinates implementations across services
- Shared spec repository prevents architectural drift
- Contract-driven specs (OpenAPI, AsyncAPI) enforce boundaries

## Getting Started

1. **Pick a pilot feature**: Start with one isolated piece of work, not an entire system
2. **Write a spec**: Use the template (Objective, Requirements, Architecture, Testing, Boundaries)
3. **Get human sign-off**: Phase 1 checkpoint is critical
4. **Plan architecture**: Explicit technical decisions before implementation
5. **Task breakdown**: Granular, verifiable steps
6. **Generate and review**: Use your existing agent tool; focus on PR review

Tools like GitHub Spec Kit provide templates and automation; Claude Code Skills let you encode your team's conventions upfront.

## Resources

- **GitHub Spec Kit**: Open-source toolkit with CLI commands and agent integrations
- **AWS Kiro**: https://kiro.dev (agentic IDE with EARS support)
- **Thoughtworks Research**: Spec-driven development as emerging 2025 practice
- **Intent-Driven.dev**: Comprehensive SDD workflows guide

## Key Takeaway

Vibe coding—unstructured prompt-driven development—works for prototypes but scales poorly. SDD trades upfront specification discipline for downstream consistency, auditability, and reduced implementation drift. AI amplifies your thinking; if your thinking is precise (spec), the amplification produces reliable results. If it's vague (vibe), it produces expensive technical debt.
