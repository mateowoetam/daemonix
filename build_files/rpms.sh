#!/bin/bash

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
  ghostty
)

dnf install --setopt=install_weak_deps=False -y "${PACKAGES[@]}"
