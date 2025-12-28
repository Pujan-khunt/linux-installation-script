#!/usr/bin/env bash

# Strict mode for shell scripts prevents inconsistent install state.
set -eEo pipefail

# Set installation directory to where this script is located.
INSTALL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p "$INSTALL_DIR"

# Source all necessary modules
source "$INSTALL_DIR/modules/logging.sh"
source "$INSTALL_DIR/modules/sudoers.sh"
source "$INSTALL_DIR/modules/master-cleanup.sh"
source "$INSTALL_DIR/modules/packages.sh"

info "Starting setup..."

ask_sudo

info "Package installation starts..."

install_yay

success "Installation completed."
