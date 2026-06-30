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
| **glab** (GitLab CLI) | GitLab API + git HTTPS auth |
| **docker** + buildx + compose | Docker-in-Docker (daemon starts via entrypoint) |
| Node.js 20, Python 3 | Language runtimes |

## Requirements

- Docker
- bash

## Installation

### npm (recommended)

```bash
npm install -g kra-ai-native
```

This installs the `kra-ai-native` command globally. The bundled `Dockerfile` and config overlay are referenced in-place from `node_modules`, so `npm update -g kra-ai-native` refreshes them automatically — but it does **not** rebuild the Docker image. The launcher only builds the image if `kra-ai-native:latest` is missing, so an existing image keeps running until you explicitly rebuild it.

### Updating

After upgrading the package (either path), rebuild the image to pick up the new files:

```bash
kra-ai-native update     # rebuild with --pull (refreshes base images too)
```

Or, for a clean rebuild from scratch:

```bash
docker rmi kra-ai-native:latest
kra-ai-native build
```

The image is ~2.5 GB; a rebuild takes a few minutes. Once rebuilt, new launches use the updated image automatically.

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

`install.sh` copies the project files to `~/.local/share/kra-ai-native` and installs the `kra-ai-native` command to `/usr/local/bin` (or `~/.local/bin` if you don't have write access to `/usr/local/bin`). Existing `devenv` and `aidev` installs are migrated automatically.

## Usage

```bash
# Launch an interactive zsh shell in the current directory
kra-ai-native

# Open the current directory in Neovim
kra-ai-native nvim .

# Build (or rebuild) the Docker image explicitly
kra-ai-native build

# Rebuild with refreshed base images
kra-ai-native update
```

The container mounts `$PWD` to `/workspace`. No host credentials (git config, SSH keys, or API tokens) are forwarded — secrets are sourced from 1Password via the pre-installed `op` CLI inside the container.

### Docker (Docker-in-Docker)

The container ships with a full Docker Engine (plus `buildx` and `compose` v2 plugins). The inner `dockerd` is started automatically by the entrypoint on launch, so `docker`, `docker buildx`, and `docker compose` are ready immediately. `kra-ai-native` runs the container with `--privileged`, which the daemon requires.

```bash
docker info
docker run --rm hello-world
docker build -t myimage .
docker compose up
```

The inner Docker image and build cache are **ephemeral** — they live in the container's writable layer and are discarded when the `--rm` container exits, so base images are re-pulled each session.

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
   | `gitlab` | `token` (PAT with `api`, `write_repository` scopes) | `glab` CLI + git HTTPS auth |
   | `opencode-zen` | `api-key` (from [opencode.ai/auth](https://opencode.ai/auth)) | OpenCode Zen inference |

3. Create a 1Password **service account** scoped to the DevContainer vault (read access). Save the token — you'll paste it into `creds` each session.

### Loading credentials

```bash
creds
```

This prompts for your 1Password service account token (hidden input), then resolves all `op://` references from `~/.config/kra-ai-native/credentials.env` into your shell environment:

- `GIT_AUTHOR_NAME` / `GIT_AUTHOR_EMAIL` → `git config --global user.name/email`
- `GH_TOKEN` → `gh` CLI + `gh auth setup-git` (wires git HTTPS auth)
- `GITLAB_TOKEN` → `glab` CLI + git credential helper (wires git HTTPS auth)
- `OPENCODE_API_KEY` → OpenCode Zen inference

The template at `~/.config/kra-ai-native/credentials.env` uses `op://DevContainer/...` references. Override the path with the `CREDS_TEMPLATE` environment variable if your vault or item names differ.

## Configuration

| Environment variable | Default | Description |
|----------------------|---------|-------------|
| `KRA_AI_NATIVE_IMAGE` | `kra-ai-native:latest` | Docker image name/tag to use |
| `KRA_AI_NATIVE_HOME` | `~/.local/share/kra-ai-native` | Directory where kra-ai-native stores its files |
| `KRA_AI_NATIVE_NO_BANNER` | unset | Set to any value to suppress the startup banner |

## Project structure

```
.
├── Dockerfile          # Container definition
├── entrypoint.sh       # UID/GID remapping entrypoint
├── kra-ai-native       # Launcher script
├── install.sh          # Host installation script
├── bin/
│   └── kra-ai-native.js  # npm launcher shim (sets KRA_AI_NATIVE_HOME, execs the bash script)
├── package.json        # npm package manifest
└── home/
    ├── .zshrc          # Zsh configuration
    ├── .config/
    │   ├── starship.toml
    │   ├── bat/
    │   ├── lazygit/
    │   └── kra-ai-native/
    └── nvim-overlay/   # AstroNvim plugin customisations
```

## License

MIT
