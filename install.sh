#!/usr/bin/env bash


# Strict mode for shell scripts prevents inconsistent install state.
set -eEo pipefail

LOG_FILE="/var/log/archlinux_installation_$(date +%Y%m%d_%H%M%S).log"

# Define colors using tput (Safer than ANSI)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
BOLD=$(tput bold)
RESET=$(tput sgr0)

# Generic parent logger. Used to create single functionality child loggers.
# Usage: _log <color> <level> <message>
_log() {
  local color=$1
  local level=$2
  local message=$3
  local timestamp=$(date "+%Y-%m-%d %H:%M:%S")

  # Log to terminal in a colored and consistent format.
  printf "${timestamp} ${color}[${level}]${RESET} $message\n"
  printf "${timestamp} [${level}] $message\n" >> "$LOG_FILE"
}

# Public logging functions
# Usage: info|success|warn|error <message>
info()    { _log "$BLUE" "INFO" "$1"; }
success() { _log "$GREEN" "OK" "$1"; }
warn()    { _log "$YELLOW" "WARN" "$1"; }
error()   { _log "$RED" "ERROR" "$1"; }

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
    info "Installation script requires sudo privileges."

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
    info "This script was ran with sudo. Password not needed again."
  fi
}
ask_sudo
