#!/usr/bin/env bash
set -euo pipefail

have() { command -v "$1" >/dev/null 2>&1; }

# --- Install basic deps (handles Debian/Ubuntu, Alpine, RHEL) ---
if have apt-get; then
  sudo apt-get update -y
  sudo apt-get install -y curl unzip xz-utils git ca-certificates
elif have apk; then
  sudo apk update
  sudo apk add --no-cache curl unzip xz git ca-certificates bash
elif have dnf; then
  sudo dnf install -y curl unzip xz git ca-certificates
elif have yum; then
  sudo yum install -y curl unzip xz git ca-certificates
else
  echo "Unsupported package manager. Please install curl/unzip/xz/git manually."
fi

# --- Install Flutter (stable) ---
FLUTTER_DIR="/usr/local/flutter"
if [ ! -d "$FLUTTER_DIR" ]; then
  sudo mkdir -p /usr/local
  curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.22.2-stable.tar.xz \
    | sudo tar -xJ -C /usr/local
fi

# Ensure on PATH for all future shells
if [ -d /usr/local/flutter/bin ]; then
  if [ -w /etc/profile.d ]; then
    echo 'export PATH="/usr/local/flutter/bin:$PATH"' | sudo tee /etc/profile.d/flutter.sh >/dev/null
  fi
fi

# For the current shell/session:
export PATH="/usr/local/flutter/bin:$PATH"

flutter --version || true
flutter config --enable-web || true