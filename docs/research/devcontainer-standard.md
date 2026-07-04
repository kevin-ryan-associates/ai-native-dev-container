# The Development Container (devcontainer) Standard

## What is a Development Container?

A development container is a standardized, containerised development environment defined via a declarative specification. Rather than developers installing dependencies locally, a devcontainer specifies the exact container image, tool configuration, extensions, and runtime dependencies needed for a project in a single `devcontainer.json` file.

Developers check out the repository, open it in a container-aware IDE (VS Code, JetBrains IDEs, or CLI tools like the `devcontainer` CLI), and the environment is automatically provisioned — ensuring consistency across machines, CI/CD pipelines, and team members.

## Who Maintains It?

The devcontainer specification is maintained by **Microsoft** in collaboration with the open-source community. The primary repositories are:

- **[devcontainers/spec](https://github.com/devcontainers/spec)** — The formal specification and reference implementations
- **[devcontainers/cli](https://github.com/devcontainers/cli)** — The open-source CLI tool (Apache 2.0 license) for building and running devcontainers without IDE dependency
- **[devcontainers/images](https://github.com/devcontainers/images)** — Pre-built, curated container images for common development stacks

The specification is vendor-neutral and the CLI is open-source, allowing implementations beyond VS Code (e.g., JetBrains, open-source tools).

## Why the Standard Exists

Development environments are a source of friction in software teams:

1. **"Works on my machine" problem** — Local setup varies by developer, OS, and installed versions. Docker solves environment drift, but `Dockerfile` alone doesn't capture IDE config, debugging setup, or extension requirements.

2. **Onboarding overhead** — New developers spend hours configuring their local environment. A devcontainer can reduce that to minutes.

3. **CI/CD consistency** — Using the same container locally and in CI ensures build, test, and lint results are reproducible.

4. **Cross-platform development** — Windows, macOS, and Linux developers can work against identical environments.

5. **Tool ecosystem fragmentation** — Without a standard, each team builds custom setup scripts. The devcontainer spec provides a common language.

6. **IDE-independent provisioning** — CLI tooling (like `devcontainer up` and `devcontainer exec`) allows teams to use devcontainers in non-IDE workflows (Neovim, custom tooling, headless CI).

## Key Features

- **Declarative configuration** via `devcontainer.json`
- **Image or Dockerfile-based** — use pre-built images or define a custom `Dockerfile`
- **Feature system** — reusable, composable setup blocks (e.g., install Node.js, Python, Docker CLI)
- **Forwarded ports** — expose container ports to the host
- **Volume mounts** — bind local directories or named volumes
- **Post-create hooks** — run scripts after the container starts
- **Extensions/tools** — specify IDE extensions or shell utilities to install
- **Lifecycle hooks** — `onCreateCommand`, `postCreateCommand`, `postStartCommand`

## Basic Examples

### Example 1: Node.js Development

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

This uses Microsoft's official Node.js 18 image, installs Git via a feature, forwards port 3000, and runs `npm install` after container creation.

### Example 2: Python with Custom Dependencies

```json
{
  "image": "mcr.microsoft.com/devcontainers/python:3.11",
  "features": {
    "ghcr.io/devcontainers/features/github-cli:1": {}
  },
  "mounts": [
    "source=/var/run/docker.sock,target=/var/run/docker.sock,type=bind"
  ],
  "postCreateCommand": "pip install -r requirements.txt",
  "customizations": {
    "vscode": {
      "extensions": ["ms-python.python", "ms-python.pylance"]
    }
  }
}
```

This uses Python 3.11, adds GitHub CLI, bind-mounts the Docker socket (for Docker-in-Docker), installs Python dependencies, and configures VS Code extensions.

### Example 3: Multi-Container Setup with Docker Compose

```json
{
  "dockerComposeFile": "docker-compose.yml",
  "service": "app",
  "workspaceFolder": "/workspace",
  "customizations": {
    "vscode": {
      "extensions": ["ms-vscode-remote.remote-containers"]
    }
  },
  "postCreateCommand": "npm install && npm run migrate"
}
```

This references a `docker-compose.yml` for multi-service orchestration (e.g., app + database), specifies the primary service, and runs setup commands.

## External Resources

- **[containers.dev](https://containers.dev)** — Official devcontainer documentation and quick-start guides
- **[GitHub devcontainers/spec](https://github.com/devcontainers/spec)** — Full specification and discussion
- **[devcontainer CLI](https://github.com/devcontainers/cli)** — Apache 2.0 open-source CLI for non-IDE usage
- **[Pre-built Images](https://github.com/devcontainers/images)** — Curated images for Node.js, Python, Go, .NET, Java, and more
- **[Features Registry](https://containers.dev/features)** — Reusable feature definitions

## CLI-Based Workflow (Sovereignty Alternative)

For teams prioritizing vendor independence or avoiding IDE lock-in, the `devcontainer` CLI provides a lightweight harness:

```bash
devcontainer up --workspace-folder .
devcontainer exec --workspace-folder . npm run build
```

This allows devcontainers to integrate into Neovim, tmux, custom shells, and headless CI without VS Code dependency.
