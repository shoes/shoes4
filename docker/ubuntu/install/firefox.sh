#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

echo "Install Firefox"
apt-get update 
apt-get install -y firefox-esr
apt-mark hold firefox-esr
apt-get clean -y