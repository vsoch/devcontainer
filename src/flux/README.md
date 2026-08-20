# flux

Everything you need to build flux-core and flux-sched, and a non-root user to do
it as.

```json
{
  "image": "ghcr.io/vsoch/devcontainer/images/flux:latest",
  "remoteUser": "vscode"
}
```

That's the whole `devcontainer.json`. The cmake extension and the git safe
directory setup are stored in the image and get picked up automatically. Pin
`:latest` to a commit sha if you want it to stop moving.

## What's in it

Built on `fluxrm/flux-core:bookworm`. The boost libraries, `libyaml-cpp-dev`,
`libedit-dev`, `python3-yaml`, and `ninja-build` for the build, plus `fd-find`,
`ripgrep`, `bats`, and `less` because you'll want them once you're in there.
`LD_LIBRARY_PATH` is set to `/usr/lib:/usr/local/lib`, which is what you want if
you're installing to `/usr/local`.

The `vscode` user is uid and gid 1000 with passwordless sudo, granted through a
drop-in in `/etc/sudoers.d` so `/etc/sudoers` keeps its `@includedir` line —
which is what lets the claude feature add its own rule on top.

## Changing it

Edit the [Dockerfile](Dockerfile) and push; there's no version to bump. If you
build it yourself, `USERNAME`, `USER_UID`, and `USER_GID` are build args:

```console
devcontainer build --workspace-folder . --config src/flux/image.json \
  --image-name my-flux
```

Adding Claude Code on top is a feature away — see [../claude](../claude).
