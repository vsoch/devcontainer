# claude

Use Claude code with features.

```json
"features": {
  "ghcr.io/vsoch/devcontainer/claude:1": {}
}
```

Or just use the container we publish, which is this feature already applied to the flux image:

```json
{
  "image": "ghcr.io/vsoch/devcontainer/images/claude:latest",
  "remoteUser": "vscode"
}
```

## Setup

### Credentials

Do this **before** you open the container. The firewall uses this file on build so you need to set your API endpoint.  Copy [claude.env.example](claude.env.example) into your project as `.devcontainer/claude.env` and change to your liking. Then "reopen in container" in VSCode. To change the path to this file in your `devcontainer.json`:

```json
"containerEnv": {
  "CLAUDE_ENV_FILE": "${containerWorkspaceFolder}/config/claude.env"
}
```

### Firewall

At startup, `init-firewall.sh` drops all outbound traffic except GitHub, DNS,
SSH, your host network, and whatever you list in `ALLOWED_DOMAINS`. You can customize this in the claude environment file too. The firewall is run by `claude-start.sh`, set as the feature's `postStartCommand`.

### Permissions

[settings.json](settings.json) blocks reads and edits of `~/.claude`, `.env`, `.env.*`, and `secrets/`.
