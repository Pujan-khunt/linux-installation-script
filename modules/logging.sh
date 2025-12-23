#!/usr/bin/env bash

LOG_DIR="$INSTALL_DIR/logs"
LOG_FILE="$LOG_DIR/install-($(date +%Y-%m\-%d\)-\(%H-%M-%S\)).log"

# Define colors using tput (Safer than ANSI)
RED=$(tput setaf 1 2>/dev/null || true)
GREEN=$(tput setaf 2 2>/dev/null || true)
YELLOW=$(tput setaf 3 2>/dev/null || true)
BLUE=$(tput setaf 4 2>/dev/null || true)
BOLD=$(tput bold 2>/dev/null || true)
RESET=$(tput sgr0 2>/dev/null || true)

# Generic parent logger. Used to create single functionality child loggers.
# Usage: _log <color> <level> <message> [padding]
_log() {
  local color=$1 level=$2 message=$3 padding=$4
  local timestamp=$(date "+%Y-%m-%d %H:%M:%S")

  # Log to terminal in a colored and consistent format.
  printf "${timestamp} ${color}[${level}]${RESET} $message\n"

  # Log to log file in a padded format without colors.
  printf "${timestamp} [${level}]${padding} $message\n" >>"$LOG_FILE"
}

# Public logging functions
# Usage: info|success|warn|error <message>
info() { _log "$BLUE" "INFO" "$1" " "; }
success() { _log "$GREEN" "OK" "$1" "   "; }
warn() { _log "$YELLOW" "WARN" "$1" " "; }
error() { _log "$RED" "ERROR" "$1" ""; }

log_crash_report() {
  if [[ ${ERROR_DETAILS[code]} -ne 0 ]]; then
    {
      printf "===============================================\n"
      printf "CRASH REPORT GENERATED AT %s\n" "${ERROR_DETAILS[time]}"
      printf "Command: %s\n" "${ERROR_DETAILS[cmd]}"
      printf "Source: %s:%s\n" "${ERROR_DETAILS[file]}" "${ERROR_DETAILS[line]}"
      printf "Exit Code: %s\n" "${ERROR_DETAILS[code]}"
      printf "===============================================\n"
    } >>"$LOG_FILE"
  fi
}

mkdir -p "$LOG_DIR"
info "Created directory to store logs at: $LOG_DIR"

# Create/empty-out log file.
true >"$LOG_FILE" 2>/dev/null
info "Logging initialized. Saving all logs to $LOG_FILE"
