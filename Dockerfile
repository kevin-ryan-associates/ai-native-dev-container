FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Base system + standard CLI toolbelt for a snappy terminal UX.
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    wget \
    git \
    zsh \
    ripgrep \
    fd-find \
    fzf \
    bat \
    jq \
    htop \
    tree \
    less \
    man-db \
    build-essential \
    cmake \
    pkg-config \
    python3 \
    python3-pip \
    python3-venv \
    xz-utils \
    unzip \
    tar \
    gzip \
    locales \
    gosu \
  && rm -rf /var/lib/apt/lists/* \
  && ln -s /usr/bin/batcat /usr/local/bin/bat \
  && ln -s /usr/bin/fdfind /usr/local/bin/fd

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
  && apt-get update \
  && apt-get install -y --no-install-recommends nodejs \
  && rm -rf /var/lib/apt/lists/*

ENV NVIM_VERSION=0.11.0
RUN curl -fsSL -o /tmp/nvim-linux-x86_64.tar.gz \
    https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-linux-x86_64.tar.gz \
  && tar -C /opt -xzf /tmp/nvim-linux-x86_64.tar.gz \
  && ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim \
  && rm -f /tmp/nvim-linux-x86_64.tar.gz

# Standalone binaries (latest pre-built releases).
# starship prompt
RUN curl -fsSL https://starship.rs/install.sh | sh -s -- -y -b /usr/local/bin

# eza (modern ls)
ENV EZA_VERSION=0.20.13
RUN curl -fsSL -o /tmp/eza.tar.gz https://github.com/eza-community/eza/releases/download/v${EZA_VERSION}/eza_x86_64-unknown-linux-gnu.tar.gz \
  && tar -C /usr/local/bin -xzf /tmp/eza.tar.gz \
  && rm -f /tmp/eza.tar.gz

# zoxide (smarter cd)
RUN curl -fsSL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash -s -- --bin-dir /usr/local/bin

# delta (better git diffs)
ENV DELTA_VERSION=0.18.2
RUN curl -fsSL -o /tmp/delta.deb https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_amd64.deb \
  && dpkg -i /tmp/delta.deb \
  && rm -f /tmp/delta.deb

# yq
ENV YQ_VERSION=v4.44.3
RUN curl -fsSL -o /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 \
  && chmod +x /usr/local/bin/yq

# lazygit
ENV LAZYGIT_VERSION=0.44.1
RUN curl -fsSL -o /tmp/lazygit.tar.gz https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz \
  && tar -C /usr/local/bin -xzf /tmp/lazygit.tar.gz lazygit \
  && rm -f /tmp/lazygit.tar.gz

# 1Password CLI (secrets inside the container, none forwarded from host).
ENV OP_VERSION=2.34.1
RUN curl -fsSL -o /tmp/op.zip \
    "https://cache.agilebits.com/dist/1P/op2/pkg/v${OP_VERSION}/op_linux_amd64_v${OP_VERSION}.zip" \
  && unzip -d /tmp/op /tmp/op.zip \
  && mv /tmp/op/op /usr/local/bin/op \
  && rm -rf /tmp/op /tmp/op.zip \
  && groupadd -f onepassword-cli \
  && chgrp onepassword-cli /usr/local/bin/op \
  && chmod g+s /usr/local/bin/op \
  && op --version

# GitHub CLI (git HTTPS auth + GitHub API via GH_TOKEN).
ENV GH_VERSION=2.95.0
RUN curl -fsSL -o /tmp/gh.tar.gz \
    "https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_amd64.tar.gz" \
  && tar -C /tmp -xzf /tmp/gh.tar.gz \
  && mv "/tmp/gh_${GH_VERSION}_linux_amd64/bin/gh" /usr/local/bin/gh \
  && rm -rf /tmp/gh.tar.gz "/tmp/gh_${GH_VERSION}_linux_amd64" \
  && gh --version

RUN (userdel -r ubuntu 2>/dev/null || true) \
  && groupadd -g 1000 dev \
  && useradd -m -u 1000 -g 1000 -s /usr/bin/zsh dev

# AstroNvim template pinned to a specific commit for reproducibility.
ENV ASTRONVIM_TEMPLATE_REF=49a7161b776f8bc6c23508819ea1ad4e7b359bee

USER dev
ENV HOME=/home/dev
WORKDIR /home/dev

# AstroNvim
RUN git clone https://github.com/AstroNvim/template /home/dev/.config/nvim \
  && cd /home/dev/.config/nvim \
  && git checkout ${ASTRONVIM_TEMPLATE_REF} \
  && rm -rf .git

# AstroNvim user overlay (custom plugin specs).
COPY --chown=dev:dev home/nvim-overlay/lua/plugins/ /home/dev/.config/nvim/lua/plugins/

# First sync: clone all plugins and run their build hooks (treesitter parsers etc.).
RUN nvim --headless "+Lazy! sync" +qa 2>&1 | tail -n 30 \
  && nvim --headless "+MasonToolsInstall" "+sleep 120" +qa 2>&1 | tail -n 30 || true

# Second sync: belt-and-braces reconcile after overlay specs are in place,
# so first interactive launch has zero pending Lazy work.
RUN nvim --headless "+Lazy! sync" +qa 2>&1 | tail -n 20 || true

# OpenCode (AI coding agent). Installs to $HOME/.opencode/bin/opencode for the
# dev user. We pass --no-modify-path because we manage PATH ourselves in .zshrc.
RUN curl -fsSL https://raw.githubusercontent.com/anomalyco/opencode/master/install -o /tmp/opencode-install.sh \
  && bash /tmp/opencode-install.sh --no-modify-path \
  && rm -f /tmp/opencode-install.sh \
  && /home/dev/.opencode/bin/opencode --version

# Shell config (zsh + starship + plugins via zinit).
COPY --chown=dev:dev home/.zshrc /home/dev/.zshrc
COPY --chown=dev:dev home/.config/starship.toml /home/dev/.config/starship.toml
COPY --chown=dev:dev home/.config/bat /home/dev/.config/bat
COPY --chown=dev:dev home/.config/aidev /home/dev/.config/aidev

# Pre-install zinit and plugins so first shell launch is instant.
# .zshrc bootstraps zinit on first run; we trigger it twice (first run clones
# zinit + plugins, second run installs the deferred turbo plugins).
RUN zsh -i -c 'exit' >/dev/null 2>&1 || true \
  && zsh -i -c 'zinit update --all -p; exit' >/dev/null 2>&1 || true

USER root
COPY entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint \
  && chown -R 1000:1000 /home/dev

WORKDIR /workspace
ENTRYPOINT ["/usr/local/bin/entrypoint"]
CMD ["zsh"]
