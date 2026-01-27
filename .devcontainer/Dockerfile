FROM mcr.microsoft.com/devcontainers/base:ubuntu

# ── Node.js (needed for Claude Code and other JS-based tools) ─────
RUN apt-get update && apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# ── Claude Code ───────────────────────────────────────────────────
RUN npm install -g @anthropic-ai/claude-code

COPY setup-claude.sh /usr/local/bin/setup-claude.sh
RUN chmod +x /usr/local/bin/setup-claude.sh
