# Mr. Meeseeks Box

A devcontainer for experimenting and developing with AI coding tools. Supports Claude Code, OpenCode, and Codex CLI - enable only what you need.

## Quick Start

1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```

2. Edit `.env` to enable the tools you want (set to `true`):
   ```bash
   ENABLE_CLAUDE_CODE=true
   ENABLE_OPENCODE=true
   ENABLE_CODEX=true
   ```

3. Open in your IDE and start the devcontainer:
   - **VS Code**: "Reopen in Container"
   - **JetBrains**: Open the devcontainer configuration
   - **CLI**: `docker compose up -d && docker compose exec meeseeks zsh`

## Tool Setup

### Claude Code

After the container starts, run:
```bash
claude
```

This starts the OAuth authentication flow:
1. Claude Code prints a URL to the terminal
2. Open that URL in your browser on the host machine
3. Complete the login in your browser
4. Copy the token/code shown after login
5. Paste it back into the terminal

**Authentication:** OAuth credentials are stored in a Docker volume. They persist when stopping/starting the container, but **not across container rebuilds** - you'll need to re-authenticate after a rebuild.

**Settings persistence:** Claude Code settings can be mounted from your host machine, so your configuration persists across rebuilds. Set these in `.env`:
```bash
CLAUDE_SETTINGS_PATH=~/.claude/settings.json
CLAUDE_MCP_PATH=~/.claude/mcp.json
```

### OpenCode

Run `opencode` and follow the prompts to authenticate with your provider.

**Persistence:** OpenCode config can be mounted from your host machine (config and data directories), so your credentials persist across rebuilds. Set these in `.env`:
```bash
OPENCODE_CONFIG_PATH=~/.config/opencode
OPENCODE_DATA_PATH=~/.local/share/opencode
```

### Codex CLI

Run `codex` and follow the authentication prompts for OpenAI.

**Persistence:** Codex config can be mounted from your host machine, so your credentials persist across rebuilds. Set in `.env`:
```bash
CODEX_PATH=~/.codex
```

**Note:** Node.js is only installed when `ENABLE_CODEX=true` since it's required for Codex but not the other tools.

## Git and SSH Configuration

By default, the container mounts your host's `~/.ssh` and `~/.gitconfig`:

```bash
SSH_PATH=~/.ssh
GITCONFIG_PATH=~/.gitconfig
```

### Security Recommendation

Consider creating separate SSH keys and git config specifically for devcontainer use:

1. **Create a dedicated SSH key:**
   ```bash
   mkdir -p ~/.ssh-devcontainer
   ssh-keygen -t ed25519 -f ~/.ssh-devcontainer/id_ed25519 -C "devcontainer"
   ```
   Add this key to your GitHub/GitLab account.

2. **Create a dedicated git config:**
   ```bash
   cp ~/.gitconfig ~/.gitconfig-devcontainer
   # Edit as needed
   ```

3. **Update your `.env`:**
   ```bash
   SSH_PATH=~/.ssh-devcontainer
   GITCONFIG_PATH=~/.gitconfig-devcontainer
   ```

This isolates your devcontainer credentials from your main development environment.

## Zsh Configuration

To use your host's zsh configuration:
```bash
ZSHRC_PATH=~/.zshrc
```

Otherwise the container uses a default zsh configuration.

## Container User

The container runs as the `meeseeks` user (UID 1000) with sudo privileges. This avoids running as root, which is required by Claude Code for security reasons.

## Data Persistence

| Tool | Storage Type | Persists on stop/start | Persists on rebuild |
|------|---------|------------------------|---------------------|
| Claude Code (auth) | Docker volume | Yes | No - re-auth required |
| Claude Code (settings) | Host mount (optional) | Yes | Yes |
| OpenCode | Host mount (optional) | Yes | Yes |
| Codex | Host mount (optional) | Yes | Yes |

### Summary

- **Claude Code authentication**: Always stored in Docker volume, lost on rebuild
- **Claude Code settings**: Mounted from host if you set `CLAUDE_SETTINGS_PATH` and `CLAUDE_MCP_PATH`
- **OpenCode & Codex**: Mounted from host if you set their respective paths, otherwise stored in container (lost on rebuild)

To change where tools store data, edit these in `.env`:
```bash
# Claude Code settings (auth is always in Docker volume)
CLAUDE_SETTINGS_PATH=~/.claude/settings.json
CLAUDE_MCP_PATH=~/.claude/mcp.json

# OpenCode
OPENCODE_CONFIG_PATH=~/.config/opencode
OPENCODE_DATA_PATH=~/.local/share/opencode

# Codex
CODEX_PATH=~/.codex
```
