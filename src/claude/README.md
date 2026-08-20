# claude

Claude Code, a firewall that keeps it from talking to anywhere you didn't ask
for, and a shared set of permission rules.

```json
"features": {
  "ghcr.io/vsoch/devcontainer/claude:1": {}
}
```

Works on any Debian or Ubuntu base image. Node 22 comes from the official node
feature, since Debian's is older than Claude Code supports.

Or skip the install and use the container we publish, which is this feature
already applied to the [flux](../flux) image:

```json
{
  "image": "ghcr.io/vsoch/devcontainer/images/claude:latest",
  "remoteUser": "vscode"
}
```

## Point it at your endpoint

Nothing comes from your host, so you have to hand it credentials. There's a
template inside the container:

```console
$ cp /usr/local/share/claude-devcontainer/claude.env.example .devcontainer/claude.env
```

Fill it in, add `.devcontainer/claude.env` to your `.gitignore`, and open a new
terminal — your shell sources it on start. If you're talking to
`api.anthropic.com`, the only line you need is `ANTHROPIC_API_KEY`. Everything
else in [claude.env.example](claude.env.example) is for a gateway, and the model
names in there are placeholders you'll need to replace with real ones.

Keeping the file in your workspace rather than your home directory means it
survives a container rebuild. If you'd rather put it somewhere else, say so:

```json
"containerEnv": {
  "CLAUDE_ENV_FILE": "${containerWorkspaceFolder}/config/claude.env"
}
```

## The firewall

On start, `init-firewall.sh` drops all outbound traffic except GitHub, DNS, SSH,
your host network, and whatever you list in `ALLOWED_DOMAINS`. That defaults to
`api.anthropic.com`.

The catch: if you set `ANTHROPIC_BASE_URL` to a gateway, you have to add that
host to `ALLOWED_DOMAINS` too, or nothing gets out. Both live in `claude.env`.
After changing it:

```console
$ sudo /usr/local/bin/init-firewall.sh "$CLAUDE_ENV_FILE"
```

This needs `NET_ADMIN`, which the feature requests for you.

## Permission rules

[settings.json](settings.json) lands in the user's `~/.claude/` and blocks reads
and edits of `~/.claude`, `.env`, `.env.*`, and `secrets/`. Two things worth
knowing:

- It covers the file tools and the file commands Claude Code recognizes in Bash,
  like `cat` and `sed`. A script that opens a file itself gets through. Turn on
  [sandboxing](https://code.claude.com/docs/en/sandboxing) if you need the
  kernel to enforce it.
- Paths anchor to wherever you started Claude Code, not your repo root.

Because these are user-level settings, a project can add stricter rules in
`.claude/settings.json` and they'll merge — but a project can't loosen these
ones, since deny always wins.

There are deliberately no model names or endpoints in here. A `settings.json`
`env` block overrides your shell, so anything in it can't be changed by an
export, and anyone without access to that particular gateway would be stuck.
That's what `claude.env` is for.

## Options

| Option | Default | What it does |
| --- | --- | --- |
| `version` | `latest` | Which `@anthropic-ai/claude-code` to install from npm |
