#!/bin/bash

# RPM FUSION
sudo dnf5 install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# FLATHUB
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# COPR
dnf -y copr enable scottames/ghostty

# LIBREWOLF
dnf config-manager addrepo --from-repofile=https://repo.librewolf.net/librewolf.repo
