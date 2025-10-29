#!/bin/bash

# RPM FUSION
sudo dnf5 install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# DOCKER
dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo

# FLATHUB
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# COPR
dnf -y copr enable scottames/ghostty
dnf -y copr enable atim/heroic-games-launcher

# MICROSOFT
rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

# LIBREWOLF

dnf config-manager addrepo --from-repofile=https://repo.librewolf.net/librewolf.repo