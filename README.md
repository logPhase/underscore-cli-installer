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
4. Pulls the container image `ghcr.io/logphase/underscore-cli:<wrapper version>`
   (~1.5 GB, one-time). The installer reads the version out of the wrapper
   it just downloaded — wrapper and image are pinned together and cannot
   drift.

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
podman rmi $(podman images -q ghcr.io/logphase/underscore-cli)    # or: docker rmi
```

## About this repo

This is the public distribution repo for the `underscore` wrapper. It
contains only `install.sh` and `bin/underscore` — the actual analyzer
source lives in the private [logphase/underscore-cli](https://github.com/logphase/underscore-cli)
repo and ships as a container image on GHCR.

The wrapper here is the canonical source — edit `bin/underscore` and
`install.sh` directly. The wrapper's `UNDERSCORE_VERSION` constant pins
the image tag the installer will pull, so bumping the wrapper version
and publishing a matching image is the release flow.

For issues and documentation, request access to the main repo.
