#!/bin/bash
set -e

# Install Docker Desktop for macOS via brew cask

brew install --cask docker

echo ""
echo "Docker Desktop installed."
echo "Open Docker from Applications to start the daemon."
echo "In Preferences > Resources > Memory, set needed amount (4-6GB for Selenium)."
