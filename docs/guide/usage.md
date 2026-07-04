# Usage

Launch an interactive zsh shell in the current directory:

```bash
ainative
```

Open the current directory in Neovim:

```bash
ainative nvim .
```

Build (or rebuild) the Docker image explicitly:

```bash
ainative build
```

Rebuild with refreshed base images:

```bash
ainative update
```

The container mounts `$PWD` to `/workspace`. No host credentials (git config, SSH keys, or API tokens) are forwarded — secrets are sourced from 1Password via the pre-installed `op` CLI inside the container.

## Docker (Docker-in-Docker)

The container ships with a full Docker Engine (plus `buildx` and `compose` v2 plugins). The inner `dockerd` is started automatically by the entrypoint on launch, so `docker`, `docker buildx`, and `docker compose` are ready immediately. `ainative` runs the container with `--privileged`, which the daemon requires.

```bash
docker info
docker run --rm hello-world
docker build -t myimage .
docker compose up
```

The inner Docker image and build cache are **ephemeral** — they live in the container's writable layer and are discarded when the `--rm` container exits, so base images are re-pulled each session.

## UID/GID passthrough

The entrypoint automatically remaps the `engineer` user inside the container to match your host UID/GID (`HOST_UID` / `HOST_GID`), so files created in `/workspace` are owned by you on the host.

## Upgrading from `kra-ai-native`

Existing installs at `~/.local/share/kra-ai-native` and `~/.config/kra-ai-native` are migrated automatically to `~/.local/share/ainative` and `~/.config/ainative` the next time `install.sh` runs. The legacy `kra-ai-native` command symlink is removed. The previously built `kra-ai-native:latest` Docker image is orphaned by the new default tag `ainative:latest`; reclaim it with `docker rmi kra-ai-native:latest` once you've rebuilt under the new name (`ainative update`).
