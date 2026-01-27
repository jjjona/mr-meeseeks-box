#!/bin/bash
set -e

# ── Claude Code setup ──────────────────────────────────────────────
# Following https://foldr.uk/claude-code-pro-subscription-docker/
#
# Claude Code stores OAuth tokens in ~/.claude/.credentials.json
# and onboarding state in ~/.claude.json.
# Docker volumes can only mount directories, so we symlink the
# standalone file into the directory to keep everything in one volume.

# Skip if Claude Code is not installed
if ! command -v claude &> /dev/null; then
  exit 0
fi

CLAUDE_DIR="/home/vscode/.claude"

# The named volume may be owned by root on first creation — fix it.
sudo chown -R vscode:vscode "$CLAUDE_DIR" 2>/dev/null || true

mkdir -p "$CLAUDE_DIR"

# Symlink ~/.claude.json → ~/.claude/claude.json so the named volume
# persists onboarding state across container rebuilds.
if [ ! -e "/home/vscode/.claude.json" ]; then
  echo '{}' > "$CLAUDE_DIR/claude.json"
  ln -sf "$CLAUDE_DIR/claude.json" "/home/vscode/.claude.json"
fi
