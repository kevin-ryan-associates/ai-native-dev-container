#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AINATIVE_HOME=${AINATIVE_HOME:-$HOME/.local/share/ainative}

# Migrate from old devenv location if it exists
if [ -d "$HOME/.local/share/devenv" ] && [ ! -d "$AINATIVE_HOME" ]; then
  echo "Migrating $HOME/.local/share/devenv -> $AINATIVE_HOME"
  mv "$HOME/.local/share/devenv" "$AINATIVE_HOME"
fi

# Migrate from old aidev location if it exists
if [ -d "$HOME/.local/share/aidev" ] && [ ! -d "$AINATIVE_HOME" ]; then
  echo "Migrating $HOME/.local/share/aidev -> $AINATIVE_HOME"
  mv "$HOME/.local/share/aidev" "$AINATIVE_HOME"
fi
if [ -d "$HOME/.config/aidev" ] && [ ! -d "$HOME/.config/ainative" ]; then
  echo "Migrating $HOME/.config/aidev -> $HOME/.config/ainative"
  mv "$HOME/.config/aidev" "$HOME/.config/ainative"
fi

# Migrate from the previous kra-ai-native install location if it exists
if [ -d "$HOME/.local/share/kra-ai-native" ] && [ ! -d "$AINATIVE_HOME" ]; then
  echo "Migrating $HOME/.local/share/kra-ai-native -> $AINATIVE_HOME"
  mv "$HOME/.local/share/kra-ai-native" "$AINATIVE_HOME"
fi
if [ -d "$HOME/.config/kra-ai-native" ] && [ ! -d "$HOME/.config/ainative" ]; then
  echo "Migrating $HOME/.config/kra-ai-native -> $HOME/.config/ainative"
  mv "$HOME/.config/kra-ai-native" "$HOME/.config/ainative"
fi

mkdir -p "$AINATIVE_HOME"

# Migrate from the old flat layout (Dockerfile/entrypoint.sh/home at the
# install root) to the new docker/ subdirectory layout.
if [ -f "$AINATIVE_HOME/Dockerfile" ] && [ ! -f "$AINATIVE_HOME/docker/Dockerfile" ]; then
  echo "Migrating $AINATIVE_HOME to the docker/ layout"
  mkdir -p "$AINATIVE_HOME/docker"
  for f in Dockerfile entrypoint.sh home; do
    [ -e "$AINATIVE_HOME/$f" ] && mv "$AINATIVE_HOME/$f" "$AINATIVE_HOME/docker/$f"
  done
fi

cp "$ROOT_DIR/ainative" "$AINATIVE_HOME/ainative"

# Sync the docker build context (Dockerfile, entrypoint, home overlay, etc.).
rm -rf "$AINATIVE_HOME/docker"
cp -R "$ROOT_DIR/docker" "$AINATIVE_HOME/docker"

chmod +x "$AINATIVE_HOME/docker/entrypoint.sh" "$AINATIVE_HOME/ainative"

# Remove legacy command symlinks if present.
for legacy in devenv aidev kra-ai-native; do
  if [ -e "/usr/local/bin/$legacy" ] && [ -w /usr/local/bin ]; then
    rm -f "/usr/local/bin/$legacy"
  fi
  if [ -e "$HOME/.local/bin/$legacy" ]; then
    rm -f "$HOME/.local/bin/$legacy"
  fi
done

if [ -w /usr/local/bin ]; then
  install -m 0755 "$AINATIVE_HOME/ainative" /usr/local/bin/ainative
  echo "Installed ainative to /usr/local/bin/ainative"
else
  mkdir -p "$HOME/.local/bin"
  install -m 0755 "$AINATIVE_HOME/ainative" "$HOME/.local/bin/ainative"
  echo "Installed ainative to $HOME/.local/bin/ainative"
  echo "Ensure $HOME/.local/bin is on your PATH"
fi

echo "Files copied to $AINATIVE_HOME"