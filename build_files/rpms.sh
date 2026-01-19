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
  filelight
  kdebugsettings
  fcitx5
)

dnf remove -y "${RM_PACKAGES[@]}"

# Installed RPMS

PACKAGES=(
  distrobox
  fastfetch
  libavcodec-freeworld
  mpv
  gamescope
  gamemode
  VK_hdr_layer
  btop
  alacritty
  librewolf
)

dnf install --setopt=install_weak_deps=False -y "${PACKAGES[@]}"
