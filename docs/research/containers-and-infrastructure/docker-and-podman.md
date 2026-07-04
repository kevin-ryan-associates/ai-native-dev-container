# Docker and Podman: Open-Source Standing and Comparison

## Why This Needs Clarifying

"Is Docker open source?" has no single answer because "Docker" refers to several distinct things with different licences. Most confusion — and most accidental licence-compliance risk — comes from treating the open-source engine and the proprietary desktop product as one item. This page separates the components, states where each stands, and compares Docker with Podman as an alternative.

## Docker: Component by Component

Docker is a stack of separately-licenced parts, not a monolith.

**Docker CLI** (`docker/cli`) is open source under Apache 2.0. This is the `docker` command itself.

**Docker Engine / daemon** — the `dockerd` process, developed in the open as part of the **Moby** project (`moby/moby`) — is open source under Apache 2.0. This is the actual container engine.

**containerd**, the runtime beneath the daemon, is open source under Apache 2.0 and is a graduated **CNCF** project rather than something Docker owns outright.

**The image and registry formats** are open standards governed by the **Open Container Initiative (OCI)**, so building and running containers never locks you to Docker's own tooling.

**Docker Desktop** is the one proprietary piece. It is the packaged application for macOS, Windows, and Linux that bundles the engine, CLI, Compose, a Linux VM, Kubernetes integration, credential helpers, and a management GUI. It is free for personal use, education, non-commercial open source, and small businesses, but requires a paid subscription for commercial use once an organisation has **250 or more employees OR $10 million or more in annual revenue**. The trigger is the size of the company using it, not the individual developer — a single engineer at a large firm cannot sidestep it with a personal account.

The practical upshot: on Linux you can install Docker Engine and the CLI directly and run a fully open-source, licence-free Docker stack with no Desktop involved. The licensing obligation only attaches to Docker Desktop, which exists mainly because macOS and Windows can't run Linux containers natively and need the bundled VM.

## Podman: Fully Open Source

Podman is open source under Apache 2.0, maintained by **Red Hat** (IBM) alongside a community. There is no proprietary "desktop" tier gating commercial use — Podman Desktop, the optional GUI, is itself open source under Apache 2.0. This is the core reason Podman is reached for in sovereignty- and compliance-sensitive contexts: the entire toolchain is open, with no per-seat licence to track.

## The Architectural Difference

The two tools do the same job but are built on different models, and the differences are what actually matter when choosing between them.

**Daemon vs daemonless.** Docker runs a persistent, privileged background daemon (`dockerd`) that all commands talk to. Podman is daemonless — each command runs as its own short-lived process with nothing left running in the background. That means a smaller attack surface and no single long-lived privileged service to secure or restart.

**Root vs rootless.** Docker's daemon traditionally runs as root (rootless mode exists but is not the default). Podman runs rootless by default: containers run under your own user account, so a container breakout doesn't hand an attacker root on the host. For most security and sovereignty postures this is the more significant of the two differences.

**CLI compatibility.** Podman's CLI is deliberately command-compatible with Docker's. In many workflows `alias docker=podman` covers day-to-day use, and existing Dockerfiles build unchanged because both consume the same OCI formats.

**Orchestration.** This is where the swap is least seamless. Docker Compose is a mature, first-class part of the Docker experience. Podman supports it — either by exposing a Docker-compatible socket that `docker compose` can target, or via `podman compose` and Kubernetes-style YAML (`podman kube`) — but a complex Compose setup may need adjustment rather than dropping in untouched.

## At a Glance

| Component | Open source? | Licence | Maintained by |
|---|---|---|---|
| Docker CLI | Yes | Apache 2.0 | Docker Inc. / Moby community |
| Docker Engine (daemon) | Yes | Apache 2.0 | Moby project |
| containerd (runtime) | Yes | Apache 2.0 | CNCF |
| Image/registry format | Yes (open standard) | — | Open Container Initiative |
| Docker Desktop | No | Proprietary | Docker Inc. |
| Podman | Yes | Apache 2.0 | Red Hat / community |
| Podman Desktop | Yes | Apache 2.0 | Red Hat / community |

## Choosing Between Them

The decision is not "Docker is proprietary, Podman is open" — that framing is wrong. Open-source Docker (Engine + CLI on Linux) and Podman are both fully open and licence-free. The real distinctions are:

- **If you want to avoid a Docker Desktop subscription** on Mac/Windows at a company past the size thresholds, the options are Podman (with Podman Desktop), Docker Engine under a free alternative runtime (e.g. Colima, Rancher Desktop), or a paid Docker plan.
- **If security architecture is the priority**, Podman's daemonless, rootless-by-default design is the stronger default, whereas Docker centres on a root daemon even though rootless mode is available.
- **If Compose-based multi-container orchestration is core to your workflow**, Docker remains the more turnkey option; Podman gets there but occasionally needs socket or config adjustment.

For a fully open, self-hostable container stack with no proprietary dependency and no per-seat licence, either open-source Docker on Linux or Podman qualifies — Podman simply gives you the more defensible security posture out of the box.

## References

- [Docker Engine (Moby) on GitHub](https://github.com/moby/moby) — Apache 2.0
- [Docker CLI on GitHub](https://github.com/docker/cli) — Apache 2.0
- [containerd (CNCF)](https://github.com/containerd/containerd) — Apache 2.0
- [Open Container Initiative](https://opencontainers.org/)
- [Docker Desktop licence terms](https://docs.docker.com/subscription/desktop-license/)
- [Podman](https://podman.io/) — Apache 2.0
