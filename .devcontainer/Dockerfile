FROM ubuntu:22.04

# ── Build arguments (opt-in via env vars) ──────────────────────────
ARG ENABLE_CLAUDE_CODE=false
ARG ENABLE_OPENCODE=false
ARG ENABLE_CODEX=false
ARG NODE_VERSION=22
ARG USERNAME=meeseeks
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ENV IN_DOCKER=1
ENV DEBIAN_FRONTEND=noninteractive

# ── Install base packages ──────────────────────────────────────────
# Disable universe repo to speed up apt-get update on ARM (all our packages are in main)
RUN sed -i 's/^deb \(.*\) universe$/# deb \1 universe/' /etc/apt/sources.list && \
  apt-get update && apt-get install -y \
  curl \
  git \
  zsh \
  locales \
  gnupg \
  ca-certificates \
  sudo \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# ── Set up locales ─────────────────────────────────────────────────
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen

# ── Create non-root user ───────────────────────────────────────────
RUN groupadd --gid $USER_GID $USERNAME \
  && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -s /bin/zsh \
  && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
  && chmod 0440 /etc/sudoers.d/$USERNAME

# ── Install Node.js (only if Codex CLI is enabled) ─────────────────
RUN if [ "$ENABLE_CODEX" = "true" ]; then \
  echo "Installing Node.js for Codex CLI..." && \
  curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - && \
  apt-get install -y nodejs && \
  apt-get clean && rm -rf /var/lib/apt/lists/*; \
  else \
  echo "Skipping Node.js install (Codex not enabled)"; \
  fi

# ── Install Claude Code (opt-in via ENABLE_CLAUDE_CODE=true) ───────
# Uses native installer (recommended) - auto-updates in background
ENV PATH="/home/${USERNAME}/.local/bin:/home/${USERNAME}/.opencode/bin:$PATH"
USER $USERNAME
RUN if [ "$ENABLE_CLAUDE_CODE" = "true" ]; then \
  echo "Installing Claude Code..." && \
  curl -fsSL https://claude.ai/install.sh | bash && \
  mkdir -p /home/${USERNAME}/.claude; \
  else \
  echo "Skipping Claude Code install"; \
  fi

# ── Install OpenCode (opt-in via ENABLE_OPENCODE=true) ─────────────
RUN if [ "$ENABLE_OPENCODE" = "true" ]; then \
  echo "Installing OpenCode..." && \
  curl -fsSL https://opencode.ai/install | bash -s -- --no-modify-path && \
  mkdir -p /home/${USERNAME}/.config/opencode; \
  else \
  echo "Skipping OpenCode install"; \
  fi

# ── Install Codex CLI (opt-in via ENABLE_CODEX=true) ───────────────
USER root
RUN if [ "$ENABLE_CODEX" = "true" ] && command -v npm > /dev/null 2>&1; then \
  echo "Installing Codex CLI..." && \
  npm install -g @openai/codex && \
  mkdir -p /home/${USERNAME}/.codex && chown $USERNAME:$USERNAME /home/${USERNAME}/.codex; \
  elif [ "$ENABLE_CODEX" = "true" ]; then \
  echo "ERROR: ENABLE_CODEX=true but npm not found. Node.js install may have failed." && exit 1; \
  else \
  echo "Skipping Codex CLI install"; \
  fi

# ── Copy entrypoint and setup scripts ──────────────────────────────
COPY entrypoint.sh /entrypoint.sh
COPY setup-tools.sh /usr/local/bin/setup-tools.sh
RUN chmod +x /entrypoint.sh /usr/local/bin/setup-tools.sh

USER $USERNAME

ENTRYPOINT ["/entrypoint.sh"]
CMD ["zsh"]

