#!/bin/bash
set -e

# ── Claude Code setup ──────────────────────────────────────────────
# Settings are mounted to /tmp/claude-host/ then symlinked into the volume
# This allows host settings to persist while keeping auth in the Docker volume
if command -v claude &> /dev/null; then
  CLAUDE_DIR="$HOME/.claude"
  mkdir -p "$CLAUDE_DIR"

  # Symlink ~/.claude.json -> ~/.claude/claude.json so the named volume
  # persists onboarding state across container rebuilds.
  if [ ! -e "$HOME/.claude.json" ]; then
    echo '{}' > "$CLAUDE_DIR/claude.json"
    ln -sf "$CLAUDE_DIR/claude.json" "$HOME/.claude.json"
  fi

  # Symlink settings from host mount (if provided and is a file)
  if [ -f "/tmp/claude-host/settings.json" ]; then
    rm -rf "$CLAUDE_DIR/settings.json"
    ln -sf /tmp/claude-host/settings.json "$CLAUDE_DIR/settings.json"
  fi
  if [ -f "/tmp/claude-host/mcp.json" ]; then
    rm -rf "$CLAUDE_DIR/mcp.json"
    ln -sf /tmp/claude-host/mcp.json "$CLAUDE_DIR/mcp.json"
  fi
fi

# ── OpenCode setup ─────────────────────────────────────────────────
if command -v opencode &> /dev/null; then
  mkdir -p "$HOME/.config/opencode" "$HOME/.local/share/opencode"
fi

# ── Codex setup ────────────────────────────────────────────────────
if command -v codex &> /dev/null; then
  mkdir -p "$HOME/.codex"
fi
