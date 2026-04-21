# underscore-cli installer

Public installer for [underscore](https://github.com/logphase/underscore-cli) —
a CLI that analyzes C# and Java codebases and produces a spatial
visualization you can explore in the browser.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/logphase/underscore-cli-installer/main/install.sh | bash
```

The installer:

1. Checks that `podman` or `docker` is installed and running.
2. Downloads the `underscore` wrapper to `~/.underscore/bin/underscore`.
3. Adds that directory to your `PATH` (`.zshrc` or `.bashrc`).
4. Pulls the container image `ghcr.io/logphase/underscore-cli:latest`
   (~1.5 GB, one-time).

Then:

```bash
# Restart your shell or source your profile, then:
underscore analyze https://github.com/dotnet/aspnetcore
underscore analyze ./path/to/local/repo
underscore pr ./path/to/repo --base main
```

## Prerequisites

- **Podman** (preferred) or **Docker** installed and running.
- For macOS, give the VM enough resources:
  - Memory ≥ 8 GB, CPUs ≥ 4 (Docker Desktop / OrbStack / colima / `podman machine`).
  - OrbStack recommended for the fastest file-mount performance.

## Uninstall

```bash
rm -rf ~/.underscore
podman rmi ghcr.io/logphase/underscore-cli:latest    # or: docker rmi
```

## About this repo

This is a thin, **auto-generated** distribution repo containing only
`install.sh` and the `underscore` wrapper. Both are synced from the main
(private) [logphase/underscore-cli](https://github.com/logphase/underscore-cli)
repo on every push. Do not edit files here directly — changes will be
overwritten by the next sync.

For source, issues, and documentation, request access to the main repo.
