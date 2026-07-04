# AI-Native Dev Container

> **⚠️ Early-stage project — use with caution.**
>
> This codebase is highly volatile and under active early-stage development. APIs, commands, and configuration are likely to change without notice. Feedback and contributions are welcome, but think twice before relying on it in production environments.

A Docker-based AI-native development environment with a curated CLI toolbelt, Neovim (AstroNvim), and [OpenCode](https://opencode.ai) pre-installed and ready to use.

<figure>

| Tool | Purpose |
|------|---------|
| **zsh** + zinit | Shell with plugin management |
| **Neovim 0.11** + AstroNvim | Full IDE experience |
| **OpenCode** | AI coding agent |
| **starship** | Fast, customisable prompt |
| **eza** | Modern `ls` replacement |
| **bat** | `cat` with syntax highlighting |
| **ripgrep** / **fd** | Fast search tools |
| **fzf** | Fuzzy finder |
| **zoxide** | Smarter `cd` |
| **delta** | Better git diffs |
| **lazygit** | Terminal UI for git |
| **yq** / **jq** | YAML/JSON processors |
| **op** (1Password CLI) | Secrets management |
| **gh** (GitHub CLI) | GitHub API + git HTTPS auth |
| **glab** (GitLab CLI) | GitLab API + git HTTPS auth |
| **docker** + buildx + compose | Docker-in-Docker (daemon starts via entrypoint) |
| Node.js 20, Python 3 | Language runtimes |

</figure>

## Requirements

- Docker
- bash

## Installation

### npm (recommended)

```bash
npm install -g ainative
```

This installs the `ainative` command globally. The bundled `Dockerfile` and config overlay are referenced in-place from `node_modules`, so `npm update -g ainative` refreshes them automatically — but it does **not** rebuild the Docker image. The launcher only builds the image if `ainative:latest` is missing, so an existing image keeps running until you explicitly rebuild it.

### curl

```bash
curl -fsSL https://raw.githubusercontent.com/kevin-ryan-associates/ai-native-dev-container/main/install.sh | bash
```

Or clone and install manually:

```bash
git clone git@github.com:kevin-ryan-associates/ai-native-dev-container.git
cd ai-native-dev-container
bash install.sh
```

`install.sh` copies the project files to `~/.local/share/ainative` and installs the `ainative` command to `/usr/local/bin` (or `~/.local/bin` if you don't have write access to `/usr/local/bin`). Existing `devenv`, `aidev`, and `kra-ai-native` installs are migrated automatically.

### Updating

After upgrading the package (either path), rebuild the image to pick up the new files:

```bash
ainative update     # rebuild with --pull (refreshes base images too)
```

Or, for a clean rebuild from scratch:

```bash
docker rmi ainative:latest
ainative build
```

The image is ~2.5 GB; a rebuild takes a few minutes. Once rebuilt, new launches use the updated image automatically.
