# Dev Container (GitHub Codespaces / VS Code / `devcontainer` CLI)

This repo ships a minimal `.devcontainer/` (Ubuntu 24.04, `engineer` user) for hacking on the project itself.

## CLI

```bash
# one-time
npm install -g @devcontainers/cli

# build & up (auto-builds then starts in the background)
devcontainer up --workspace-folder .

# exec a shell inside it
devcontainer exec --workspace-folder . zsh

# force a rebuild (new Dockerfile/dockerfile.json changes)
devcontainer up --workspace-folder . --remove-existing-container

# tear down (stops and removes the container)
docker rm -f $(docker ps --filter label=devcontainer.local_folder=$(pwd) -aq)
```

The first `up` builds the image; subsequent calls reuse the container. The workspace is bind-mounted at `/workspace`.
