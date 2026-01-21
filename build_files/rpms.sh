#!/bin/sh
set -e

# Removed RPMs
set -- \
    firefox \
    htop \
    nvtop \
    kfind \
    krfb \
    kcharselect \
    kde-connect \
    kwalletmanager \
    kdebugsettings \
    fcitx5

dnf remove -y "$@"

# Installed RPMs
set -- \
    opendoas \
    dash \
    fish \
    distrobox \
    fastfetch \
    libavcodec-freeworld \
    vlc \
    gamescope \
    gamemode \
    VK_hdr_layer \
    alacritty \
    librewolf \
    dangerzone

dnf install --setopt=install_weak_deps=False -y "$@"
