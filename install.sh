#!/usr/bin/env bash

# Strict mode for shell scripts prevents inconsistent install state.
set -eEo pipefail

refresh_sudo() {
  while true; do
    # Non-interactively refresh sudo cache.
    # If password is required it will throw error message and exit with non-zero status code, stopping the script.
    sudo -n true 2>/dev/null

    # Wait before refreshing sudo cache again.
    sleep 60
  done
}

ask_sudo() {
  # Check if root access is already granted when running this script.
  # i.e. this script is ran with 'sudo'.
  if [ "$EUID" -ne 0 ]; then
    echo "Installation script requires sudo privileges."

    # Updates sudo cache (asks password once if required).
    # Proceeds without prompting for password if sudo was used recently.
    sudo -v

    # Run sudo refresher as a background process.
    refresh_sudo &

    # Store PID before it is overwritten.
    SUDO_REFRESHER_PID=$!

    # Kill the sudo refresher process either when the script exits successfully or by force by the user.
    trap 'kill $SUDO_REFRESHER_PID 2>/dev/null || true' EXIT INT
  else
    echo "This script was ran with sudo. Password not needed again."
  fi
}
