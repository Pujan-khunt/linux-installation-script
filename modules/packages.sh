install_yay() {
  local YAY_REPO_URL="https://aur.archlinux.org/yay.git"

  # Check if yay is already installed.
  if command -v yay &>/dev/null; then
    info "Yay is already installed."
    return
  fi

  info "Installing Yay (AUR Helper)..."
  sudo pacman -S --needed --noconfirm git base-devel go >>"$LOG_FILE" 2>&1

  # Build yay in temporary directory.
  local temp_dir=$(mktemp -d)
  git clone "$YAY_REPO_URL" "$temp_dir/yay" >>"$LOG_FILE" 2>&1

  # Visit, build and unvisit temporary directory.
  pushd "$temp_dir/yay" >/dev/null

  info "Building Yay..."
  makepkg --noconfirm >>"$LOG_FILE" 2>&1

  info "Installing Yay binary..."
  local pkg_file=$(find . -name "yay*.pkg.tar.zst" | head -n 1)
  warn "PKGFILE = $pkg_file"
  sudo pacman -U --noconfirm "$pkg_file" >>"$LOG_FILE" 2>&1

  popd >/dev/null
  # rm -rf "$temp_dir"

  success "Yay installed successfully."
}
