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

The container mounts `$PWD` to `/workspace` and forwards your `~/.gitconfig` and `~/.ssh` directory (read-only) so git and SSH work out of the box.

### UID/GID passthrough

The entrypoint automatically remaps the `dev` user inside the container to match your host UID/GID (`HOST_UID` / `HOST_GID`), so files created in `/workspace` are owned by you on the host.

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
