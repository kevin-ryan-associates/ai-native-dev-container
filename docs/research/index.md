# Research

This section collects background research, standards, and technical deep-dives that inform the design of the AI-Native Dev Container.

## Topics

- [EU Digital Sovereignty](./eu-digital-sovereignty) — The legal landscape (GDPR, AI Act, CLOUD Act) and why open-source/open-weights are the only futureproof architecture for sovereign systems.
- [AI Coding Agents](./ai-coding-agents) — A survey of the AI coding agent landscape, organised around open-source vs proprietary and model-agnostic vs locked providers.
- [How Coding Agents Swap Models](./how-coding-agents-swap-models) — The technical foundation that makes model-agnostic agents possible: the OpenAI Chat Completions format as a de facto wire standard.
- [The Harness](./the-harness) — What a coding agent really is: the loop, the three components, and why the harness is where the gains are.
- [Developing the Harness](./developing-the-harness) — The practical craft of tuning, extending, and hardening a harness — context engineering, tooling, guardrails, evaluation, and observability.
- [Model Selection](./model-selection) — How to choose a model as a routing strategy: the five axes, the tiering pattern, open-weight vs frontier, and why benchmarks are a weak signal.
- [The Development Container Standard](./devcontainer-standard) — A deep dive into the devcontainer specification, its origins, and how it solves the "works on my machine" problem.
- [Docker and Podman](./docker-and-podman) — Clarifying the open-source status of each component, and a practical comparison of the two container engines.
- [Container Registries](./container-registries) — How container images are stored, distributed, and verified; Docker Hub as the proprietary default; and why publishing and consuming are separate decisions.
- [npm Package Registries](./npm-package-registries) — The dependency supply chain for JavaScript, the Microsoft-owned default registry, and how to control it with lockfiles and self-hosted alternatives.
