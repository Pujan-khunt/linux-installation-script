sudo_cleanup() {
  if [[ -n $SUDO_REFRESHER_PID ]]; then
    # Kill sudo refresher
    kill "$SUDO_REFRESHER_PID" 2>/dev/null || true

    if [[ ${ERROR_DETAILS[code]} -ne 0 ]]; then
      warn "Sudo refresher killed due to error."
    else
      success "Sudo refresher killed due to successfull script completion."
    fi
  else
    warn "Sudo refresher process doesn't exist."
  fi
}

_refresh_sudo() {
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
    info "Installation script requires sudo privileges."

    # Updates sudo cache (asks password once if required).
    # Proceeds without prompting for password if sudo was used recently.
    sudo -v

    # Run sudo refresher as a background process.
    _refresh_sudo &
    info "Sudo refresher spawned."

    # Store PID before it is overwritten.
    SUDO_REFRESHER_PID=$!

    success "Sudo privileges acquired."
  else
    info "Running as root. Sudo refresh is not required."
  fi
}
