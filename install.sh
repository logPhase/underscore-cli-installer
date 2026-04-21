#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# underscore-cli installer
#
# Downloads the `underscore` wrapper into ~/.underscore/bin, adds it to PATH,
# and pulls the container image.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/logphase/underscore-cli/main/install.sh | bash
# ---------------------------------------------------------------------------

INSTALL_DIR="${HOME}/.underscore/bin"
UNDERSCORE_IMAGE="${UNDERSCORE_IMAGE:-ghcr.io/logphase/underscore-cli:latest}"
# The wrapper lives in the PUBLIC installer repo (the main underscore-cli
# repo is private). Overridable for local testing, e.g.:
#   UNDERSCORE_WRAPPER_URL="file://$PWD/bin/underscore" ./install.sh
WRAPPER_URL="${UNDERSCORE_WRAPPER_URL:-https://raw.githubusercontent.com/logphase/underscore-cli-installer/main/bin/underscore}"

BOLD="\033[1m"
GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
RESET="\033[0m"

info()  { echo -e "${BOLD}${GREEN}==>${RESET} $*"; }
warn()  { echo -e "${BOLD}${YELLOW}Warning:${RESET} $*"; }
error() { echo -e "${BOLD}${RED}Error:${RESET} $*" >&2; exit 1; }

# ---------------------------------------------------------------------------
# Container runtime check
# ---------------------------------------------------------------------------

if command -v podman >/dev/null 2>&1; then
    RUNTIME="podman"
elif command -v docker >/dev/null 2>&1; then
    RUNTIME="docker"
else
    error "Docker or Podman is required but neither is installed.
  Install Docker: https://docs.docker.com/get-docker/
  Install Podman: https://podman.io/getting-started/installation"
fi

"$RUNTIME" info >/dev/null 2>&1 || error "${RUNTIME} is installed but not running. Start it and try again."
info "Using container runtime: ${RUNTIME}"

# ---------------------------------------------------------------------------
# Install CLI wrapper
# ---------------------------------------------------------------------------

info "Installing underscore CLI to ${INSTALL_DIR}..."
mkdir -p "${INSTALL_DIR}"

if command -v curl >/dev/null 2>&1; then
    curl -fsSL "${WRAPPER_URL}" -o "${INSTALL_DIR}/underscore"
elif command -v wget >/dev/null 2>&1; then
    wget -qO "${INSTALL_DIR}/underscore" "${WRAPPER_URL}"
else
    error "curl or wget is required"
fi

chmod +x "${INSTALL_DIR}/underscore"

# ---------------------------------------------------------------------------
# Pull container image
# ---------------------------------------------------------------------------

info "Pulling underscore container image (this may take a few minutes)..."
if ! "$RUNTIME" pull "${UNDERSCORE_IMAGE}"; then
    rm -f "${INSTALL_DIR}/underscore"
    error "Failed to pull ${UNDERSCORE_IMAGE}.
  The installation was rolled back — no wrapper was left on your PATH."
fi

# ---------------------------------------------------------------------------
# PATH setup
# ---------------------------------------------------------------------------

add_to_path() {
    local rc_file="$1"

    if [[ -f "$rc_file" ]] && grep -q "${INSTALL_DIR}" "$rc_file" 2>/dev/null; then
        return
    fi

    echo '' >> "$rc_file"
    echo "# underscore-cli" >> "$rc_file"
    echo "export PATH=\"${INSTALL_DIR}:\$PATH\"" >> "$rc_file"
    info "Added ${INSTALL_DIR} to PATH in ${rc_file}"
}

if [[ ":$PATH:" != *":${INSTALL_DIR}:"* ]]; then
    case "${SHELL:-/bin/bash}" in
        */zsh)  add_to_path "${HOME}/.zshrc" ;;
        */bash)
            if [[ -f "${HOME}/.bash_profile" ]]; then
                add_to_path "${HOME}/.bash_profile"
            else
                add_to_path "${HOME}/.bashrc"
            fi
            ;;
        *)
            warn "Add this to your shell profile:
  export PATH=\"${INSTALL_DIR}:\$PATH\""
            ;;
    esac

    export PATH="${INSTALL_DIR}:$PATH"
fi

echo ""
info "Installation complete!"
echo ""
echo "  Get started:"
echo "    underscore analyze https://github.com/org/repo"
echo "    underscore analyze ./path/to/local/repo"
echo ""
echo "  Restart your shell or run:"
echo "    export PATH=\"${INSTALL_DIR}:\$PATH\""
echo ""
