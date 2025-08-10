#!/usr/bin/env bash
set -e

# deps
sudo apt-get update -y
sudo apt-get install -y curl unzip xz-utils libglu1-mesa

# install Flutter stable (Linux x64)
FLUTTER_DIR=/usr/local/flutter
if [ ! -d "$FLUTTER_DIR" ]; then
  sudo mkdir -p "$FLUTTER_DIR"
  curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.22.2-stable.tar.xz \
    | sudo tar -xJ -C /usr/local
  # PATH for all shells
  echo 'export PATH="/usr/local/flutter/bin:$PATH"' | sudo tee /etc/profile.d/flutter.sh >/dev/null
fi

# make sure vscode user owns cache dirs
sudo chown -R vscode:vscode /usr/local/flutter

# enable web
export PATH="/usr/local/flutter/bin:$PATH"
flutter --version
flutter config --enable-web