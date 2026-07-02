#!/usr/bin/env bash
set -euo pipefail

USER_NAME=engineer
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
  # Chown only home subdirs we own.
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

# Docker-in-Docker: start the daemon as root, then drop to the engineer user.
# Pick the best storage driver in a single attempt: kernel overlay2 when the
# container can mount it, else fuse-overlayfs (copy-on-write via FUSE) on
# Docker Desktop for macOS nested containers, else vfs as the final fallback.
gpasswd -a "$USER_NAME" docker >/dev/null 2>&1 || true

start_dockerd() {
  dockerd -G docker --host=unix:///var/run/docker.sock "$@" >/var/log/dockerd.log 2>&1 &
  DOCKER_PID=$!
}

wait_dockerd() {
  for _ in $(seq 1 60); do
    if docker info >/dev/null 2>&1; then return 0; fi
    if ! kill -0 "$DOCKER_PID" 2>/dev/null; then return 1; fi
    sleep 1
  done
  return 1
}

can_overlay() {
  local lower upper work merged
  lower=$(mktemp -d) upper=$(mktemp -d) work=$(mktemp -d) merged=$(mktemp -d)
  mount -t overlay overlay -o "lowerdir=$lower,upperdir=$upper,workdir=$work" "$merged" 2>/dev/null
  local rc=$?
  umount "$merged" 2>/dev/null || true
  rmdir "$lower" "$upper" "$work" "$merged" 2>/dev/null || true
  return $rc
}

if can_overlay; then
  storage_driver=overlay2
elif command -v fuse-overlayfs >/dev/null 2>&1 && [ -e /dev/fuse ]; then
  storage_driver=fuse-overlayfs
else
  storage_driver=vfs
fi

start_dockerd --storage-driver="$storage_driver"
if ! wait_dockerd; then
  echo "dockerd did not become ready (storage driver: $storage_driver):" >&2
  cat /var/log/dockerd.log >&2
  exit 1
fi

if [ "$#" -eq 0 ]; then
  set -- zsh
fi

exec gosu "$USER_NAME" "$@"
