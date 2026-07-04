# The Development Container (devcontainer) Standard

## Overview

A development container is a full development environment defined as code. Instead of each developer installing language runtimes, tools, and dependencies onto their own machine, a project declares everything it needs in a `devcontainer.json` file. A container-aware tool reads that file, builds or pulls the specified image, applies the configuration, and drops the developer into a ready-to-work environment. The same definition can drive local development, remote development, and CI — which is the point: one source of truth for "what this project runs in."

The specification deliberately targets the un-orchestrated single-container case as well as multi-container setups via Docker Compose, so it scales from a solo script up to an app-plus-database stack without changing tooling.

## Who Maintains It

The standard is developed in the open by the **Development Containers project**, originally initiated by Microsoft and now maintained as a community specification under the `devcontainers` GitHub organisation. It is split across a few repositories worth knowing:

- **`devcontainers/spec`** — the specification itself, licensed **CC-BY-4.0**.
- **`devcontainers/cli`** — the reference CLI implementation (TypeScript), licensed **MIT**. This is the piece that lets you use devcontainers without any IDE.
- **`devcontainers/images`**, **`devcontainers/features`**, **`devcontainers/templates`** — curated base images, composable install units, and starter templates, also MIT-licensed.

The distinction that matters for a sovereignty posture: the spec is an open, permissively licensed standard and the reference implementation is open source. Neither is bound to VS Code or to any single vendor's cloud. Microsoft stewards it, but nothing in the standard requires Microsoft's products to consume it — JetBrains IDEs, the CLI, and third-party runtimes all implement it.

## Why the Standard Exists

The problem it solves is environment drift. A `Dockerfile` captures the runtime, but it says nothing about editor configuration, debugging setup, required extensions, forwarded ports, or the post-create steps that turn a bare container into a working environment. Teams historically filled that gap with tribal knowledge and brittle setup scripts, which is exactly where "works on my machine" comes from.

The devcontainer spec closes that gap by making the whole environment declarative and reproducible. New developers go from clone to productive in minutes rather than hours. Because the same container definition can run in CI, build and test results stay consistent with what developers see locally. And because it is a shared standard rather than a per-team convention, the configuration is portable across tools and transferable between projects.

For reproducibility specifically, the CLI generates a lockfile (`.devcontainer-lock.json`) that pins feature versions, so a build today and a build in six months resolve to the same components. `--frozen-lockfile` enforces it in CI. This is the same discipline as a package lockfile, applied to the environment itself.

## The Anatomy of a devcontainer.json

The configuration is small and readable. The core fields:

- **`image`** or **`build`/`dockerFile`** — the base to start from, or a Dockerfile to build.
- **`features`** — reusable, composable install units (Git, GitHub CLI, a language runtime) pulled from a registry and layered on without hand-writing Dockerfile steps.
- **`forwardPorts`** — container ports exposed to the host.
- **`mounts`** — bind mounts or named volumes.
- **Lifecycle hooks** — `onCreateCommand`, `postCreateCommand`, `postStartCommand`, run at defined points in the container's life.
- **`customizations`** — tool-specific settings (e.g. a `vscode` block listing extensions), namespaced so they don't pollute the core spec.

## Examples

A minimal Node.js environment: pull an official image, add Git as a feature, forward the dev-server port, and install dependencies after the container is created.

```json
{
  "image": "mcr.microsoft.com/devcontainers/javascript-node:18",
  "features": {
    "ghcr.io/devcontainers/features/git:1": {}
  },
  "forwardPorts": [3000],
  "postCreateCommand": "npm install"
}
```

A Python environment with a couple of extras — GitHub CLI as a feature, editor extensions declared for anyone using VS Code, and dependencies installed on create:

```json
{
  "image": "mcr.microsoft.com/devcontainers/python:3.11",
  "features": {
    "ghcr.io/devcontainers/features/github-cli:1": {}
  },
  "postCreateCommand": "pip install -r requirements.txt",
  "customizations": {
    "vscode": {
      "extensions": ["ms-python.python", "ms-python.pylance"]
    }
  }
}
```

A multi-service setup delegating orchestration to Docker Compose — the app container is the one you work in, with a database (or anything else) defined alongside it in the compose file:

```json
{
  "dockerComposeFile": "docker-compose.yml",
  "service": "app",
  "workspaceFolder": "/workspace",
  "postCreateCommand": "npm install && npm run migrate"
}
```

## Using It Without an IDE

The reference CLI makes devcontainers a first-class part of a terminal-driven or CI workflow, with no editor in the loop:

```bash
# Bring the environment up from a devcontainer.json
devcontainer up --workspace-folder .

# Run a command inside it
devcontainer exec --workspace-folder . npm run build

# Pre-build/cache an image for CI
devcontainer build --workspace-folder .
```

This is what makes the standard viable for a Neovim/tmux workflow, headless CI, or any setup where a VS Code dependency would be unwelcome. The CLI can install via a standalone script that bundles its own Node.js runtime, so it doesn't even require a pre-existing Node install on the host.

For a fully open runtime, the spec and CLI are not tied to Docker Desktop: the container engine underneath can be swapped for rootless alternatives, and community forks exist that target Podman directly. That keeps the entire chain — standard, reference implementation, and runtime — on open, self-hostable components with no proprietary dependency and no data or build step leaving infrastructure you control.

## Resources

- **[containers.dev](https://containers.dev)** — the specification's home, with reference docs and guides
- **[devcontainers/spec](https://github.com/devcontainers/spec)** — the specification (CC-BY-4.0)
- **[devcontainers/cli](https://github.com/devcontainers/cli)** — the reference CLI (MIT)
- **[Features](https://containers.dev/features)** — registry of reusable install units
- **[Templates](https://containers.dev/templates)** — starting points for common stacks
- **[Pre-built images](https://github.com/devcontainers/images)** — curated base images for Node.js, Python, Go, Java, .NET, and more
