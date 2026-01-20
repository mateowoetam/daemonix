#!/bin/bash

# URL of the .flatpak file
Hytale_URL="https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-latest.flatpak"

# Download the .flatpak file
echo "Downloading Hytale Launcher..."
wget "https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-latest.flatpak" -O /tmp/hytale-launcher-latest.flatpak

# Check if the download was successful
if [ $? -ne 0 ]; then
    echo "Failed to download the Hytale Launcher."
    exit 1
fi

# Install the .flatpak file non-interactively
echo "Installing Hytale Launcher..."
flatpak install --noninteractive /tmp/hytale-launcher-latest.flatpak

# Check if the installation was successful
if [ $? -eq 0 ]; then
    echo "Hytale Launcher installed successfully!"
else
    echo "Failed to install Hytale Launcher."
    exit 1
fi

# Cleanup
rm /tmp/hytale-launcher-latest.flatpak
