#!/bin/bash

# Removed RPMS

RM_PACKAGES=(
  firefox
  htop
  nvtop
  kfind
  krfb
  kcharselect
  kde-connect
  kwalletmanager
  kdebugsettings
  fcitx5
)

dnf remove -y "${RM_PACKAGES[@]}"

# Installed RPMS

PACKAGES=(
  fish
  distrobox
  fastfetch
  libavcodec-freeworld
  vlc
  gamescope
  gamemode
  VK_hdr_layer
  alacritty
  librewolf
)

dnf install --setopt=install_weak_deps=False -y "${PACKAGES[@]}"
