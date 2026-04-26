# underscore-cli installer

Public installer for [underscore](https://github.com/logphase/underscore-cli) —
a CLI that analyzes C# and Java codebases and produces a spatial
visualization you can explore in the browser.

## Install

Latest:

```bash
curl -fsSL https://raw.githubusercontent.com/logphase/underscore-cli-installer/main/install.sh | bash
```

A specific version:

```bash
curl -fsSL https://raw.githubusercontent.com/logphase/underscore-cli-installer/main/install.sh | bash -s -- --version 0.1.5
```

When `--version X.Y.Z` is given, the installer fetches `bin/underscore`
from the `vX.Y.Z` git tag of this repo — so you get the wrapper code
*and* the matching image as they shipped at that release.

The installer:

1. Checks that `podman` or `docker` is installed and running.
2. Downloads the `underscore` wrapper to `~/.underscore/bin/underscore`
   (from `main` by default, or from the `vX.Y.Z` tag with `--version`).
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

Each release is a git tag (`vX.Y.Z`) on this repo, so users can install
historical versions via `--version X.Y.Z`.

For issues and documentation, request access to the main repo.
