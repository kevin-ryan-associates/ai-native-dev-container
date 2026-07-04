# Research

This section collects background research, standards, and technical deep-dives that inform the design of the AI-Native Dev Container.

## Governance & Sovereignty

- [EU Digital Sovereignty](./governance-and-sovereignty/eu-digital-sovereignty) — The legal landscape (GDPR, AI Act, CLOUD Act) and why open-source/open-weights are the only futureproof architecture for sovereign systems.

## Agents & Models

- [AI Coding Agents](./agents-and-models/ai-coding-agents) — A survey of the AI coding agent landscape, organised around open-source vs proprietary and model-agnostic vs locked providers.
- [The Harness](./agents-and-models/the-harness) — What a coding agent really is: the loop, the three components, and why the harness is where the gains are.
- [Developing the Harness](./agents-and-models/developing-the-harness) — The practical craft of tuning, extending, and hardening a harness — context engineering, tooling, guardrails, evaluation, and observability.
- [Agentic Tooling](./agents-and-models/agentic-tooling) — The anatomy of tools: where they come from (built-in, shell, MCP), what makes them good, and the safety and sovereignty dimensions.
- [How Coding Agents Swap Models](./agents-and-models/how-coding-agents-swap-models) — The technical foundation that makes model-agnostic agents possible: the OpenAI Chat Completions format as a de facto wire standard.
- [Model Selection](./agents-and-models/model-selection) — How to choose a model as a routing strategy: the five axes, the tiering pattern, open-weight vs frontier, and why benchmarks are a weak signal.
- [The Model Ecosystem](./agents-and-models/the-model-ecosystem) — The three layers (labs, models, providers), the open-weight vs closed distinction, and why decoupling enables sovereignty.

## Containers & Infrastructure

- [The Development Container Standard](./containers-and-infrastructure/devcontainer-standard) — A deep dive into the devcontainer specification, its origins, and how it solves the "works on my machine" problem.
- [Docker and Podman](./containers-and-infrastructure/docker-and-podman) — Clarifying the open-source status of each component, and a practical comparison of the two container engines.
- [Container Registries](./containers-and-infrastructure/container-registries) — How container images are stored, distributed, and verified; Docker Hub as the proprietary default; and why publishing and consuming are separate decisions.
- [npm Package Registries](./containers-and-infrastructure/npm-package-registries) — The dependency supply chain for JavaScript, the Microsoft-owned default registry, and how to control it with lockfiles and self-hosted alternatives.

## SDLC

- [Vibe Coding, One Shots, and Spec-Driven Development](./sdlc/vibe-coding-one-shots-and-spec-driven-development) — A spectrum comparison of three AI-native development approaches and when to use each.
- [Spec-Driven Development](./sdlc/spec-driven-development) — Specifications as executable input to AI coding agents: the four phases, tooling, notation, and adoption patterns.
