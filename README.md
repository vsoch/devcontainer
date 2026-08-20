# devcontainer

VSCode Developer Container templates for use in other projects.

- **[flux](src/flux)** — build dependencies for flux-core and flux-sched, plus a non-root `vscode` user
- **[claude](src/claude)** — Claude Code, an egress firewall, and a shared set of permission rules

The `flux` subdirectory is a container, and `claude` is a
[Feature](https://containers.dev/implementors/features/) you can install onto a
base image you choose, including the flux one. We also publish the two together.
Make a `.devcontainer/devcontainer.json` in your project. To use them together:

```json
{
  "image": "ghcr.io/vsoch/devcontainer/images/flux:latest",
  "remoteUser": "vscode",
  "features": {
    "ghcr.io/vsoch/devcontainer/claude:1": {}
  }
}
```

Open the folder in VS Code and pick **Reopen in Container**. Or from a terminal:

```console
npm install -g @devcontainers/cli
devcontainer up --workspace-folder .
devcontainer exec --workspace-folder . bash
```

Swap the image for whatever you actually build on — the claude feature assumes
Debian or Ubuntu and nothing more. Read each README for what it installs and
what you can configure:

- [src/flux/README.md](src/flux/README.md)
- [src/claude/README.md](src/claude/README.md)

### Or use the built container

Flux with Claude:

```json
{
  "image": "ghcr.io/vsoch/devcontainer/images/claude:latest",
  "remoteUser": "vscode"
}
```

Or you can copy the feature folder into your project and point at it with a relative path:

```json
"features": {
  "./claude": {}
}
```

## How to tweak

Each environment is in `src/<name>/`:

| File | Description |
| --- | --- |
| `image.json` | How the published container is built |
| `Dockerfile` | The build itself — flux only |
| `devcontainer-feature.json` | Describes the feature and what it contributes — claude only |
| `install.sh` | Runs as root during the build — claude only |
| `start.sh` | Runs at container start — claude only |
| anything else | Shipped along with the feature and available to `install.sh` |

For flux, edit the Dockerfile. For claude, edit `install.sh` and bump
`version` in `devcontainer-feature.json`.
