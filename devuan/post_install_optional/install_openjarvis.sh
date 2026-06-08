#!/bin/bash
set -e

# Install OpenJarvis (local-first personal AI framework)
# Requires: ollama installed, curl, python3.10+

INSTALL_DIR="$HOME/.openjarvis"

# Check ollama is available
if ! command -v ollama &> /dev/null; then
  echo "Error: ollama not found. Install it first."
  exit 1
fi

# Run the official installer
curl -fsSL https://open-jarvis.github.io/OpenJarvis/install.sh | bash

# Install rustup for the Rust extension (Debian's rustc is usually too old)
if ! command -v ~/.cargo/bin/rustc &> /dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
export PATH="$HOME/.cargo/bin:$PATH"

# Build the Rust extension
~/.openjarvis/.scripts/build-extension.sh

# Ensure cargo env is sourced in bashrc
if ! grep -q 'cargo/env' "$HOME/.bashrc" 2>/dev/null; then
  echo '. "$HOME/.cargo/env"' >> "$HOME/.bashrc"
fi

# Verify installation
if command -v jarvis &> /dev/null; then
  echo ""
  echo "Done. Run: jarvis"
  echo "Check status: jarvis doctor"
else
  echo ""
  echo "Done. You may need to reload your shell: source ~/.bashrc"
  echo "Then run: jarvis"
fi
