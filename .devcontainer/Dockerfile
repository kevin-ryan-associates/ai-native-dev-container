FROM ubuntu:24.04

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    zsh \
    sudo \
  && rm -rf /var/lib/apt/lists/*

ARG USERNAME=engineer
ARG USER_UID=1000
ARG USER_GID=1000

RUN (userdel -r ubuntu 2>/dev/null || true) \
  && (groupdel ubuntu 2>/dev/null || true) \
  && groupadd -g ${USER_GID} ${USERNAME} \
  && useradd -m -u ${USER_UID} -g ${USER_GID} -s /usr/bin/zsh ${USERNAME} \
  && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ${USERNAME}