#!/usr/bin/env bash

# Script to automatically download and install Google Chrome with no user prompts

# Set error handling
set -e

# Ensure we're running as root
if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root. Please use sudo."
  exit 1
fi

# Create a temporary directory
TEMP_DIR=$(mktemp -d)
echo "Created temporary directory: $TEMP_DIR"

# Change to the temp directory
cd "$TEMP_DIR"

echo "Downloading Google Chrome..."
# Download the latest Chrome RPM package
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm

echo "Installing Google Chrome..."
# Install Chrome without prompting (-y flag)
dnf install -y ./google-chrome-stable_current_x86_64.rpm

echo "Cleaning up..."
# Return to the previous directory
cd - >/dev/null

# Remove the temporary directory and its contents
rm -rf "$TEMP_DIR"

echo "Google Chrome installation completed successfully!"
