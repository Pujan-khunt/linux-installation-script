#!/usr/bin/env bash

LOG_DIR="$INSTALL_DIR/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/install-($(date +%Y-%m\-%d\)-\(%H-%M-%S\)).log"

# Define colors using tput (Safer than ANSI)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
BOLD=$(tput bold)
RESET=$(tput sgr0)

# Generic parent logger. Used to create single functionality child loggers.
# Usage: _log <color> <level> <message> [padding]
_log() {
  local color=$1
  local level=$2
  local message=$3
  local padding=$4
  local timestamp=$(date "+%Y-%m-%d %H:%M:%S")

  # Log to terminal in a colored and consistent format.
  printf "${timestamp} ${color}[${level}]${RESET} $message\n"

  # Log to log file in a padded format without colors.
  printf "${timestamp} [${level}]${padding} $message\n" >> "$LOG_FILE"
}

# Public logging functions
# Usage: info|success|warn|error <message>
info()    { _log "$BLUE" "INFO" "$1" " "; }
success() { _log "$GREEN" "OK" "$1" "   "; }
warn()    { _log "$YELLOW" "WARN" "$1" " "; }
error()   { _log "$RED" "ERROR" "$1" ""; }

# Create/empty-out log file.
: > "$LOG_FILE"
info "Logging initialized. Saving all logs to $LOG_FILE"
