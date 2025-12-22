#!/usr/bin/env bash

# Strict mode for shell scripts prevents inconsistent install state.
set -eEo pipefail

INSTALL_DIR="$HOME/archlinux"
mkdir -p "$INSTALL_DIR"

source "$INSTALL_DIR/modules/logging.sh"
source "$INSTALL_DIR/modules/sudoers.sh"

info "Starting setup..."

ask_sudo

info "Package installation starts..."

success "Installation completed."
