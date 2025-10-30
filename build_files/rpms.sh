#!/bin/bash

# Removed RPMS

RM_PACKAGES=(
  firefox
  konsole
  kate
  htop
  nvtop
  kfind
  krfb
  kcharselect
  kde-connect
  kwalletmanager
  filelight
)

dnf remove -y "${RM_PACKAGES[@]}"

# Installed RPMS

PACKAGES=(
  distrobox
  fastfetch
  libavcodec-freeworld
  mpv
  steam
  heroic-games-launcher-bin
  gamescope
  gamemode
  VK_hdr_layer
  docker-ce
  docker-ce-cli
  containerd.io
  docker-buildx-plugin
  docker-compose-plugin
  code
  btop
  ghostty
  librewolf
)

dnf install --setopt=install_weak_deps=False -y "${PACKAGES[@]}"
