# AI-Native Software Development: Vibe Coding, One Shots, and Spec-Driven Development

Three distinct approaches to AI-assisted software development have emerged in 2025-2026. They represent different points on a spectrum from unstructured iteration to formal specification, each optimized for different contexts, risk profiles, and team structures.

## Quick Comparison

| Dimension | Vibe Coding | One Shots | Spec-Driven (SDD) |
|-----------|-----------|-----------|-------------------|
| **Workflow** | Iterative chat; see → say → run → iterate | Single comprehensive prompt | Phased: Specify → Plan → Tasks → Implement |
| **Structure** | Unstructured, conversational | Direct but comprehensive | Formal gates with human approval |
| **Planning** | Implicit in chat history | Upfront in prompt | Explicit, version-controlled specs |
| **Context persistence** | Chat window only | Single prompt (but can be large) | Specs live in repo; survive session ends |
| **Human oversight** | "Accept All" (minimal) | Validation after response | Checkpoint at every phase |
| **Reproducibility** | Low; depends on chat sequence | Medium; prompt can be replayed | High; specs are canonical |
| **Production readiness** | Low | Medium | High |
| **Setup time** | Minutes | Minutes | 5-30 minutes |
| **Team coordination** | Difficult | Difficult | Designed for it |
| **Best for** | Prototypes, exploration, weekend projects | Simple features, CLI tools | Production systems, brownfield code, distributed teams |
| **Security risk** | High; code not reviewed | Medium; single validation point | Low; gated approval + constitutional constraints |

---

## Vibe Coding: "See Stuff, Say Stuff, Run Stuff"

<cite index="30-1">Coined in February 2025 by Andrej Karpathy, vibe coding describes a coding approach where programmers rely on LLMs to generate working code by providing natural language descriptions rather than manually writing formal code, summarized as "fully give in to the vibes, embrace exponentials, and forget that the code even exists."</cite>

### How It Works

<cite index="30-1">The workflow is: "fully give in to the vibes, embrace exponentials, and forget that the code even exists. I barely even touch the keyboard. I accept all always, I don't read the diffs anymore. When I get error messages I just copy paste them in with no comment, usually that fixes it."</cite>

The process is fundamentally iterative and conversational:
1. You articulate an idea or change in natural language
2. The AI generates code
3. You test it and observe the result
4. You refine based on what you see
5. Repeat until satisfied

All context lives in chat history. No specs. No formal plan. Just continuous refinement.

### Strengths

- **Speed to prototype**: Incredibly fast for throwaway work and exploration
- **Low friction**: No upfront planning burden; start coding immediately
- **Accessibility**: Lowers barrier to entry for non-expert programmers
- **Experimentation**: Encourages rapid ideation and wild ideas

### Weaknesses

- **Context loss**: When chat history grows large, the AI loses track of earlier decisions
- **Accountability**: No record of *why* decisions were made; makes debugging and maintenance hard
- **Reproducibility**: Replicating the exact code requires replaying the same chat sequence
- **Security**: LLMs generate vulnerable code at 9.8%-42.1% rates; vibe coding provides minimal review
- **Maintainability**: Code grows "beyond comprehension" per Karpathy; future developers (and you) struggle to understand intent
- **Production risk**: <cite index="30-1">Critics point out a lack of accountability, maintainability, and an increased risk of introducing security vulnerabilities. May be suitable for prototyping or "throwaway weekend projects" but poses risks in professional settings where deep understanding is necessary for debugging, maintenance, and security.</cite>

### When to Use It

- **Rapid prototypes**: Validating if an idea is worth building
- **Exploration**: Learning how to solve a problem
- **Throwaway code**: Scripts you won't maintain
- **Personal projects**: Where you're the only stakeholder and the cost of failure is low

### The Evolution: From Vibe Coding to "Agentic Engineering"

<cite index="33-1">By February 2026, just one year after coining the term, Karpathy stated that vibe coding is now passé. Improved LLMs made it possible for programming via LLM agents to become the default workflow for professionals, but now with more oversight and scrutiny. The goal is to claim the leverage from agents but without compromise on software quality.</cite>

<cite index="33-1">Karpathy's new preferred term is "agentic engineering": "agentic because the new default is that you are not writing the code directly 99% of the time, you are orchestrating agents who do and acting as oversight — 'engineering' to emphasize that there is an art & science and expertise to it."</cite>

**Key insight**: Vibe coding works for prototypes, but production requires structure. The industry is moving toward agentic engineering—using agents for speed but with deliberate checkpoints, context curation, and validation.

---

## One Shots: "Single Comprehensive Prompt, Complete Response"

One-shot development sends a single, well-crafted, self-contained prompt to an LLM and accepts the generated response without iteration. All context, constraints, instructions, and examples are embedded in the prompt itself.

### How It Works

1. Compose a comprehensive prompt including:
   - Problem statement and requirements
   - Constraints and context
   - Code style and conventions
   - One or more examples of desired output format
   - Explicit format instructions ("return valid JSON," "write unit tests," etc.)
2. Send the prompt in a single API call
3. Receive the complete response
4. Validate and deploy (or iterate externally, outside the prompt)

### Strengths

- **Determinism**: Single API call with fixed temperature = reproducible output
- **Cost efficiency**: One call, no multi-turn overhead or context window accumulation
- **Latency**: Low communication overhead; direct question → answer
- **Caching**: Identical prompts can be cached; reduces API costs further
- **Simplicity**: No complex orchestration; straightforward request-response

### Weaknesses

- **Upfront precision burden**: The prompt must be comprehensive; vagueness leads to poor outputs
- **Inflexibility**: No iteration or feedback loop; if the output misses the mark, you must re-prompt entirely
- **Context limits**: If your requirements are complex, they may exceed token budgets
- **Debugging**: Hard to debug why the model made a choice (no conversation to trace)
- **Learning**: Model can't learn from feedback mid-session; each call is independent
- **Scale**: Not suitable for multi-phase work or coordinated changes across systems

### When to Use It

- **Simple, well-defined tasks**: Generate a single function, refactor a snippet, write a test
- **CLI tools and scripts**: One-off code generation where the spec is clear upfront
- **Cost-sensitive operations**: Batch processing where latency and cost matter more than iteration
- **Structured outputs**: Tasks where format is strict (e.g., "return valid JSON with these fields")
- **Educational examples**: Teaching LLMs how to solve similar problems via examples in the prompt

### Example Use Case

```
Generate a Python function that:
- Takes a list of dictionaries (user records with 'id', 'name', 'email')
- Filters for users whose email domain is 'company.com'
- Returns a sorted list of names (alphabetical)
- Includes docstring and type hints
- Includes a unit test that validates the function

Use this style:
[show example function]
```

Send once. Get back function + test. Done.

---

## Spec-Driven Development: "Structure Before Code"

SDD inverts the traditional workflow: specifications become the primary artifact, and code is a generated output constrained by explicit, machine-readable specs. It's the only approach designed to scale across teams, multiple repositories, and production systems.

### How It Works

Four gated phases, each with human approval before proceeding:

**Phase 1: Specify**
- Answer: "What should the software do?"
- Output: Objective, Requirements (EARS notation), Architecture, Testing Strategy, Boundaries
- Artifact: `specification.md` checked into version control

**Phase 2: Plan**
- Answer: "How will we build this?"
- Output: Technical approach, data models, APIs, dependencies, risks
- Artifact: `design.md` in the spec directory

**Phase 3: Tasks**
- Answer: "What are the concrete steps?"
- Output: Granular, verifiable tasks with dependencies
- Artifact: `tasks.md` with implementation checklist

**Phase 4: Implement**
- Execute tasks; generate code using your existing AI tool
- Artifact: Pull request against main branch, reviewed by humans

Each phase gates the next. You only move forward when humans sign off on the spec.

### Strengths

- **Accountability**: Every decision is documented; you can explain *why* architecture was chosen
- **Drift prevention**: Specs live in the repo; reference them in PRs to ensure code matches intent
- **Team alignment**: Everyone agrees on what to build *before* code is written
- **Reproducibility**: Run the exact same spec against a different model and get consistent results
- **Security governance**: Constitutional SDD embeds security constraints; CWE mappings prevent known vulnerability classes
- **Brownfield excellence**: OpenSpec's delta specs handle existing systems well; plan changes without rewriting entire spec
- **Production quality**: Scales to complex systems, microservices, distributed teams
- **Context persistence**: Specs survive chat sessions, team turnover, and architecture reviews

### Weaknesses

- **Upfront planning burden**: Requires discipline to write good specs; lazy specs → lazy code
- **Overhead**: Takes 5-30 minutes to set up and learn the workflow
- **Reduced agility**: Phase gates can feel slow if you want to iterate rapidly
- **Specification drift**: Specs can become stale; requires vigilance to keep them in sync with code
- **Team adoption**: Requires buy-in; if the team treats specs as theater, SDD fails

### When to Use It

- **Production systems**: Any code that will be maintained beyond the initial delivery
- **Brownfield/legacy**: Evolving existing systems where you need to coordinate changes
- **Distributed teams**: Multi-repo features, microservices, cross-functional coordination
- **Regulated industries**: Healthcare, fintech, defense—where audit trails and documentation are mandatory
- **Critical systems**: Payment processing, auth, data handling where correctness is non-negotiable

### Tools

- **OpenSpec**: Lightweight, brownfield-first, works with 20+ agents
- **GitHub Spec Kit**: Thorough, GitHub-integrated, phase-gated
- **AWS Kiro**: All-in-one IDE with EARS notation and Requirements Analysis
- **Claude Code Skills**: Package SDD workflows as reusable commands

---

## The Spectrum: When to Use Each

### Prototyping Phase
**Start with Vibe Coding.**
Explore ideas, test hypotheses, validate market fit. Speed trumps structure. Once you know what you're building, move to SDD.

### Simple Features in Established Systems
**Use One Shots or light Vibe Coding.**
If the task is well-scoped (e.g., "add a validation function") and the codebase is well-understood, a single prompt + validation may be sufficient. Don't over-engineer.

### Production Code, Distributed Systems, Regulatory Contexts
**Use SDD.**
The cost of vagueness, drift, and re-work is too high. Specs enforce alignment and create accountability.

### Learning & Experimentation
**Use Vibe Coding or One Shots.**
Trying to understand a new framework? Generate code quickly, iterate, learn. Once you've learned, formalize with SDD.

### High-Risk Domains
**Always use SDD + Constitutional constraints.**
Financial transactions, medical systems, authentication, data handling: drift is expensive. Specs prevent it.

---

## The Real Shift: From Vibe to Agentic Engineering

<cite index="33-1">The industry is moving away from pure vibe coding toward agentic engineering—using AI agents for speed but with deliberate structure, oversight, and scrutiny. The goal is to claim the leverage from agents without compromising software quality.</cite>

**2025 insight**: Vibe coding proved that LLMs can write code fast and surprisingly well.

**2026 reality**: Speed without structure creates technical debt. The next evolution is structure that doesn't kill speed. That's SDD.

### Key Principle: Leverage Without Compromise

> **Speed isn't the constraint; understanding and maintenance are.**

The constraint isn't how fast the AI can write code. The constraint is how well humans understand and maintain it. SDD optimizes for understanding by treating specs as the primary artifact and code as a generated artifact. Vibe coding optimizes for speed but sacrifices understanding. One-shot optimizes for directness but only works for simple tasks.

---

## Practical Guidelines

### For Individuals
- **Prototyping**: Vibe code freely; embrace exponentials
- **Personal tools**: One-shot simple tasks; vibe code complex ones
- **Maintainable code**: Switch to SDD; self-document intent via specs

### For Teams
- **Greenfield projects**: Start SDD from day one; align before coding
- **Existing codebases**: Use OpenSpec's delta specs; apply SDD incrementally per feature
- **Cross-team coordination**: SDD is non-negotiable; specs replace Slack threads and emails
- **Security-sensitive**: Constitutional SDD with CWE mappings

### For Organizations
- **Invest in spec discipline**: The highest-leverage work happens before code is written
- **Normalize human checkpoints**: Agents are fast; human oversight is where quality comes from
- **Treat specs as living assets**: Check them into git, reference in PRs, evolve them
- **Measure structural debt, not just code debt**: Vague specs are technical debt in slow motion

---

## Conclusion

Vibe coding proved that AI can write code. Agentic engineering proved that AI can write code fast. Spec-driven development proves that AI can write code fast *and sustainably*.

> **Speed isn't the constraint; understanding and maintenance are.**

Every developer has experienced inherited code that works but makes no sense. Every team has felt the pain of drift—code that doesn't match intent. Every organization has paid the price of "just ship it." AI amplifies this: it can now generate code so fast that unclear *intent* becomes the limiting factor, not coding speed.

When you vibe code, you trade structure for speed. When you one-shot, you trade iteration for determinism. When you spec, you insist that intent be clear *before* the agent starts writing. That clarity—that shared understanding of what and why—is what separates a prototype from a system.

Choose the approach that fits your risk profile, team structure, and context. But if you're building anything that needs to last, scale, or be maintained by humans—vibe your way to a prototype, then formalize with SDD.

The future isn't "AI replaces developers." It's "developers become orchestrators of AI agents, armed with specs that enforce intent."
