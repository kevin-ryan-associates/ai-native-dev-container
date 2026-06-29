#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AIDEV_HOME=${AIDEV_HOME:-$HOME/.local/share/aidev}

# Migrate from old devenv location if it exists
if [ -d "$HOME/.local/share/devenv" ] && [ ! -d "$AIDEV_HOME" ]; then
  echo "Migrating $HOME/.local/share/devenv -> $AIDEV_HOME"
  mv "$HOME/.local/share/devenv" "$AIDEV_HOME"
fi

mkdir -p "$AIDEV_HOME"
cp "$ROOT_DIR/Dockerfile" "$AIDEV_HOME/Dockerfile"
cp "$ROOT_DIR/entrypoint.sh" "$AIDEV_HOME/entrypoint.sh"
cp "$ROOT_DIR/aidev" "$AIDEV_HOME/aidev"

# Sync the home overlay (zshrc, starship, bat configs, etc.)
rm -rf "$AIDEV_HOME/home"
cp -R "$ROOT_DIR/home" "$AIDEV_HOME/home"

chmod +x "$AIDEV_HOME/entrypoint.sh" "$AIDEV_HOME/aidev"

# Remove the legacy devenv command if present
if [ -e /usr/local/bin/devenv ] && [ -w /usr/local/bin ]; then
  rm -f /usr/local/bin/devenv
fi
if [ -e "$HOME/.local/bin/devenv" ]; then
  rm -f "$HOME/.local/bin/devenv"
fi

if [ -w /usr/local/bin ]; then
  install -m 0755 "$AIDEV_HOME/aidev" /usr/local/bin/aidev
  echo "Installed aidev to /usr/local/bin/aidev"
else
  mkdir -p "$HOME/.local/bin"
  install -m 0755 "$AIDEV_HOME/aidev" "$HOME/.local/bin/aidev"
  echo "Installed aidev to $HOME/.local/bin/aidev"
  echo "Ensure $HOME/.local/bin is on your PATH"
fi

echo "Files copied to $AIDEV_HOME"
