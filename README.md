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

### Port forwarding

By default, `kra-ai-native` publishes **no ports**. Forwarding is opt-in via a project `.ai-native` file, environment variables, or CLI flags.

Create a `.ai-native` file in your project root (or any parent directory — the launcher walks up from `$PWD`):

```bash
# .ai-native (key=value format)
port_range=3000-3005
ports=5000,8080:8080
```

```bash
# Inside the container:
python3 -m http.server 3005
# On the host (another terminal):
curl localhost:3005   # works because 3005 is in the configured range
```

**Docker-in-Docker chaining:** the inner `dockerd` runs in the container's network namespace, so a service started with inner `docker compose` (or `docker run -p`) that publishes a port inside a configured range is *also* forwarded to the host automatically. Ports outside the range are only forwarded if published explicitly.

```bash
# Inside the container — forwarded because 3000 is in the range:
docker run --rm -p 3000:3000 nginx
# On the host:
curl localhost:3000   # works
```

Override or disable forwarding:

```bash
# Forward a different range via CLI
kra-ai-native --port-range 5000-5999
# Or via env var
KRA_AI_NATIVE_PORT_RANGE=5000-5999 kra-ai-native

# Add an explicit port (additive; repeatable)
kra-ai-native -p 5432:5432
kra-ai-native -p 5432:5432 -p 8080 nvim .

# Disable the automatic range (explicit -p still works)
KRA_AI_NATIVE_NO_PORTS=1 kra-ai-native
KRA_AI_NATIVE_PORT_RANGE=none kra-ai-native

# Bind a single port to localhost only
kra-ai-native -p 127.0.0.1:5432:5432
```

| Flag / variable | Effect |
|-----------------|--------|
| `.ai-native` keys | `port_range=RANGE` / `ports=SPEC1,SPEC2` — project-local defaults. |
| `-p`, `--port SPEC` | Publish one port (`3000`, `8080:8080`, `127.0.0.1:5432:5432`). Repeatable. |
| `--port-range RANGE` | Override the configured/default range. |
| `KRA_AI_NATIVE_PORT_RANGE` | Default from config or none; set to `none` to disable. |
| `KRA_AI_NATIVE_PORTS` | Comma-separated explicit ports, e.g. `3000,8080:8080`. |
| `KRA_AI_NATIVE_NO_PORTS` | Set to `1` to disable the automatic range (explicit ports still work). |

> **Warning:** Publishing a very large range (e.g. `3000-3999` = 1000 ports) can make the container appear to hang on startup because Docker binds every port and spawns a proxy process for each one before the entrypoint runs. Keep ranges small.

> **Why not `--network host`?** On Linux it would forward *every* port automatically, but on Docker Desktop for macOS/Windows the container runs in a Linux VM, so `--network host` binds to the VM — ports are **not** reachable on the Mac. Publishing a range is the reliable cross-platform approach.

### UID/GID passthrough

The entrypoint automatically remaps the `engineer` user inside the container to match your host UID/GID (`HOST_UID` / `HOST_GID`), so files created in `/workspace` are owned by you on the host.

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
| `KRA_AI_NATIVE_PORT_RANGE` | none (or `.ai-native` value) | Host-published port range; set to `none` to disable |
| `KRA_AI_NATIVE_PORTS` | unset | Comma-separated explicit ports to publish, e.g. `3000,8080:8080` |
| `KRA_AI_NATIVE_NO_PORTS` | unset | Set to `1` to disable the automatic range (explicit ports still work) |

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
