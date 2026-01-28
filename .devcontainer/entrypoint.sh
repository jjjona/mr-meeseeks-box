#!/bin/bash
set -e

# Run tool setup (Claude Code, OpenCode, Codex credential symlinks)
/usr/local/bin/setup-tools.sh

exec "$@"
