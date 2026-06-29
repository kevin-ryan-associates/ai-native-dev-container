#!/usr/bin/env bash
set -euo pipefail

USER_NAME=dev
TARGET_UID=${HOST_UID:-1000}
TARGET_GID=${HOST_GID:-1000}

CURRENT_UID=$(id -u "$USER_NAME" 2>/dev/null || echo "")
CURRENT_GID=$(id -g "$USER_NAME" 2>/dev/null || echo "")

if [ -z "$CURRENT_UID" ]; then
  groupadd -g "$TARGET_GID" "$USER_NAME"
  useradd -m -u "$TARGET_UID" -g "$TARGET_GID" -s /usr/bin/zsh "$USER_NAME"
  NEED_CHOWN=1
else
  NEED_CHOWN=0
  if [ "$CURRENT_GID" != "$TARGET_GID" ]; then
    if getent group "$TARGET_GID" >/dev/null 2>&1; then
      usermod -g "$TARGET_GID" "$USER_NAME"
    else
      groupmod -g "$TARGET_GID" "$USER_NAME"
    fi
    NEED_CHOWN=1
  fi

  if [ "$CURRENT_UID" != "$TARGET_UID" ]; then
    usermod -u "$TARGET_UID" "$USER_NAME"
    NEED_CHOWN=1
  fi
fi

mkdir -p /workspace

if [ "$NEED_CHOWN" = "1" ]; then
  # Chown only home subdirs we own, skipping read-only bind mounts
  # (.ssh and .gitconfig are commonly mounted from the host).
  for entry in /home/$USER_NAME/.config \
               /home/$USER_NAME/.local \
               /home/$USER_NAME/.cache \
               /home/$USER_NAME/.zshrc \
               /home/$USER_NAME/.zsh_history \
               /home/$USER_NAME/.zshenv \
               /home/$USER_NAME/.profile; do
    if [ -e "$entry" ]; then
      chown -R "$TARGET_UID":"$TARGET_GID" "$entry" 2>/dev/null || true
    fi
  done
  chown "$TARGET_UID":"$TARGET_GID" /home/$USER_NAME 2>/dev/null || true
fi

if [ "$#" -eq 0 ]; then
  set -- zsh
fi

exec gosu "$USER_NAME" "$@"
