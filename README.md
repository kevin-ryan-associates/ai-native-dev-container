# ai-native-dev-container

A Docker-based AI-native development environment with a curated CLI toolbelt, Neovim (AstroNvim), and [OpenCode](https://opencode.ai) pre-installed and ready to use.

## What's inside

The container is built on Ubuntu 24.04 and includes:

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
| Node.js 20, Python 3 | Language runtimes |

## Requirements

- Docker
- bash

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/kevin-ryan-associates/ai-native-dev-container/main/install.sh | bash
```

Or clone and install manually:

```bash
git clone git@github.com:kevin-ryan-associates/ai-native-dev-container.git
cd ai-native-dev-container
bash install.sh
```

`install.sh` copies the project files to `~/.local/share/aidev` and installs the `aidev` command to `/usr/local/bin` (or `~/.local/bin` if you don't have write access to `/usr/local/bin`).

## Usage

```bash
# Launch an interactive zsh shell in the current directory
aidev

# Open the current directory in Neovim
aidev nvim .

# Build (or rebuild) the Docker image explicitly
aidev build

# Rebuild with refreshed base images
aidev update
```

The container mounts `$PWD` to `/workspace`. No host credentials (git config, SSH keys, or API tokens) are forwarded — secrets are sourced from 1Password via the pre-installed `op` CLI inside the container.

### UID/GID passthrough

The entrypoint automatically remaps the `dev` user inside the container to match your host UID/GID (`HOST_UID` / `HOST_GID`), so files created in `/workspace` are owned by you on the host.

## Secrets management

The container ships with the 1Password CLI (`op`) and GitHub CLI (`gh`) pre-installed. No credentials are forwarded from the host — secrets are sourced from 1Password inside the container.

### Setup (one-time)

1. In 1Password, create a vault named **DevContainer**.
2. Create the following items in that vault:

   | Item | Fields | Purpose |
   |------|--------|---------|
   | `git` | `username`, `email` | Git commit identity |
   | `github` | `token` (PAT with `repo`, `read:org`, `workflow` scopes) | `gh` CLI + git HTTPS auth |
   | `opencode-zen` | `api-key` (from [opencode.ai/auth](https://opencode.ai/auth)) | OpenCode Zen inference |

3. Create a 1Password **service account** scoped to the DevContainer vault (read access). Save the token — you'll paste it into `creds` each session.

### Loading credentials

```bash
creds
```

This prompts for your 1Password service account token (hidden input), then resolves all `op://` references from `~/.config/aidev/credentials.env` into your shell environment:

- `GIT_AUTHOR_NAME` / `GIT_AUTHOR_EMAIL` → `git config --global user.name/email`
- `GH_TOKEN` → `gh` CLI + `gh auth setup-git` (wires git HTTPS auth)
- `OPENCODE_API_KEY` → OpenCode Zen inference

The template at `~/.config/aidev/credentials.env` uses `op://DevContainer/...` references. Override the path with the `CREDS_TEMPLATE` environment variable if your vault or item names differ.

## Configuration

| Environment variable | Default | Description |
|----------------------|---------|-------------|
| `AIDEV_IMAGE` | `aidev:latest` | Docker image name/tag to use |
| `AIDEV_HOME` | `~/.local/share/aidev` | Directory where aidev stores its files |

## Project structure

```
.
├── Dockerfile          # Container definition
├── entrypoint.sh       # UID/GID remapping entrypoint
├── aidev               # Launcher script
├── install.sh          # Host installation script
└── home/
    ├── .zshrc          # Zsh configuration
    ├── .config/
    │   ├── starship.toml
    │   ├── bat/
    │   └── aidev/
    └── nvim-overlay/   # AstroNvim plugin customisations
```

## License

MIT
