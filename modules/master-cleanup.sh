CLEANUP_DONE=0

# Create a global hashmap for storing error information.
declare -gA ERROR_DETAILS

master_cleanup() {
  # Retrieve the exit code of the failed process.
  local exit_code=${?:-0}

  # Ensure master cleanup is only run once.
  if [[ $CLEANUP_DONE -eq 1 ]]; then
    return
  fi
  CLEANUP_DONE=1

  # Capture error details
  ERROR_DETAILS[code]=${exit_code}
  ERROR_DETAILS[line]=${BASH_LINENO[0]}
  ERROR_DETAILS[cmd]=${BASH_COMMAND}
  ERROR_DETAILS[file]=${BASH_SOURCE}
  ERROR_DETAILS[time]=$(date "+%Y-%m-%d %H:%M:%S")

  # Log error for failed commands
  if [[ $exit_code -ne 0 ]]; then
    error "'${ERROR_DETAILS[cmd]}' failed at line ${ERROR_DETAILS[line]} in ${ERROR_DETAILS[file]} (code: $exit_code)"
  fi

  # Other cleanup functions
  sudo_cleanup

  info "Master cleanup completed."
}

trap master_cleanup EXIT INT TERM ERR
