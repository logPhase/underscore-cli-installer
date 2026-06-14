# underscore-cli installer

Public installer for [underscore](https://github.com/logphase/underscore-cli) —
a CLI that analyzes C#, Java, Python, and TypeScript codebases and produces a
spatial visualization you can explore in the browser.

## Install

Latest:

```bash
curl -fsSL https://raw.githubusercontent.com/logphase/underscore-cli-installer/main/install.sh | bash
```

A specific version:

```bash
curl -fsSL https://raw.githubusercontent.com/logphase/underscore-cli-installer/main/install.sh | bash -s -- --version 0.7.1
```

The installer drops `~/.underscore/bin/underscore`, adds it to your
`PATH`, and pulls the matching container image (~1.5 GB, one-time).

## Usage

```bash
underscore analyze https://github.com/dotnet/aspnetcore
underscore pr https://github.com/dotnet/eShop/pull/972
```

`analyze` produces a spatial map of the codebase; `pr` overlays the
changes from a pull request onto that map. See `underscore --help` for
the full flag list.

## Prerequisites

- **Podman** (preferred) or **Docker** installed and running.
- macOS: give the VM ≥ 8 GB RAM and ≥ 4 CPUs (Docker Desktop / OrbStack /
  colima / `podman machine`). OrbStack is recommended for fastest file
  mounts.

## Persistent state

`~/.underscore/` on the host is bind-mounted into the container, so the
following persist across `docker run --rm`:

- `~/.underscore/dotnet/` — .NET runtime + lazy-installed target SDKs
- `~/.underscore/runs/<project>/<ts>/` — output JSONs (last 5 per project, auto-pruned)
- `~/.underscore/www/` — webapp data the static server reads

The same layout is used by the Homebrew install, so a host with both
shares the SDK cache.

**Linux note:** on native Docker without user-namespace remapping,
container processes run as root and files appear root-owned on the host.
Cleanup (`underscore clean`, `rm -rf ~/.underscore`) then needs `sudo`.
Docker Desktop, OrbStack, colima, and rootless Podman all handle this
transparently.

## Uninstall

```bash
rm -rf ~/.underscore
podman rmi $(podman images -q ghcr.io/logphase/underscore-cli)    # or: docker rmi
```

## About this repo

This is the public distribution repo for the `underscore` wrapper. It
contains only `install.sh` and `bin/underscore` — the analyzer source
lives in the private [logphase/underscore-cli](https://github.com/logphase/underscore-cli)
repo and ships as a container image on GHCR.

The wrapper here is the canonical source — edit `bin/underscore` and
`install.sh` directly. The wrapper's `UNDERSCORE_VERSION` constant pins
the image tag the installer pulls, so wrapper and image are released
together. Each release is a git tag (`vX.Y.Z`); users install historical
versions via `--version X.Y.Z`.

For issues and documentation, request access to the main repo.
