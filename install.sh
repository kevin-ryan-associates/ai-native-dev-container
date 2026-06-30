#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KRA_AI_NATIVE_HOME=${KRA_AI_NATIVE_HOME:-$HOME/.local/share/kra-ai-native}

# Migrate from old devenv location if it exists
if [ -d "$HOME/.local/share/devenv" ] && [ ! -d "$KRA_AI_NATIVE_HOME" ]; then
  echo "Migrating $HOME/.local/share/devenv -> $KRA_AI_NATIVE_HOME"
  mv "$HOME/.local/share/devenv" "$KRA_AI_NATIVE_HOME"
fi

# Migrate from old aidev location if it exists
if [ -d "$HOME/.local/share/aidev" ] && [ ! -d "$KRA_AI_NATIVE_HOME" ]; then
  echo "Migrating $HOME/.local/share/aidev -> $KRA_AI_NATIVE_HOME"
  mv "$HOME/.local/share/aidev" "$KRA_AI_NATIVE_HOME"
fi
if [ -d "$HOME/.config/aidev" ] && [ ! -d "$HOME/.config/kra-ai-native" ]; then
  echo "Migrating $HOME/.config/aidev -> $HOME/.config/kra-ai-native"
  mv "$HOME/.config/aidev" "$HOME/.config/kra-ai-native"
fi

mkdir -p "$KRA_AI_NATIVE_HOME"
cp "$ROOT_DIR/Dockerfile" "$KRA_AI_NATIVE_HOME/Dockerfile"
cp "$ROOT_DIR/entrypoint.sh" "$KRA_AI_NATIVE_HOME/entrypoint.sh"
cp "$ROOT_DIR/kra-ai-native" "$KRA_AI_NATIVE_HOME/kra-ai-native"

# Sync the home overlay (zshrc, starship, bat configs, etc.)
rm -rf "$KRA_AI_NATIVE_HOME/home"
cp -R "$ROOT_DIR/home" "$KRA_AI_NATIVE_HOME/home"

chmod +x "$KRA_AI_NATIVE_HOME/entrypoint.sh" "$KRA_AI_NATIVE_HOME/kra-ai-native"

# Remove legacy command symlinks if present.
for legacy in devenv aidev; do
  if [ -e "/usr/local/bin/$legacy" ] && [ -w /usr/local/bin ]; then
    rm -f "/usr/local/bin/$legacy"
  fi
  if [ -e "$HOME/.local/bin/$legacy" ]; then
    rm -f "$HOME/.local/bin/$legacy"
  fi
done

if [ -w /usr/local/bin ]; then
  install -m 0755 "$KRA_AI_NATIVE_HOME/kra-ai-native" /usr/local/bin/kra-ai-native
  echo "Installed kra-ai-native to /usr/local/bin/kra-ai-native"
else
  mkdir -p "$HOME/.local/bin"
  install -m 0755 "$KRA_AI_NATIVE_HOME/kra-ai-native" "$HOME/.local/bin/kra-ai-native"
  echo "Installed kra-ai-native to $HOME/.local/bin/kra-ai-native"
  echo "Ensure $HOME/.local/bin is on your PATH"
fi

echo "Files copied to $KRA_AI_NATIVE_HOME"
