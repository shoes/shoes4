#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

echo "Install Chromium Browser"
apt-get update 
apt-cache search ffmpeg
apt-get install -y chromium chromium-l10n chromium-inspector
apt-get clean -y
ln -s /usr/bin/chromium /usr/bin/google-chrome
### fix to start chromium in a Docker container, see https://github.com/ConSol/docker-headless-vnc-container/issues/2
echo "CHROMIUM_FLAGS='--no-sandbox --start-maximized --user-data-dir'" > $HOME/.chromium.init
