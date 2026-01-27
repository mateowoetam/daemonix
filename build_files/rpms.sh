#!/bin/sh
set -eu
FEDORA_VERSION=$(rpm -E %fedora)
dnf remove -y \
firefox \
htop \
nvtop \
kfind \
krfb \
kcharselect \
kde-connect \
kwalletmanager \
kdebugsettings \
plasma-discover \
okular \
fcitx5
dnf install -y \
"https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$FEDORA_VERSION.noarch.rpm" \
"https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$FEDORA_VERSION.noarch.rpm"
dnf install --setopt=install_weak_deps=False -y \
libavcodec-freeworld \
VK_hdr_layer
dnf config-manager setopt rpmfusion-free.enabled=0||true
dnf config-manager setopt rpmfusion-nonfree.enabled=0||true
dnf config-manager addrepo \
--from-repofile=https://repo.librewolf.net/librewolf.repo
dnf install --setopt=install_weak_deps=False -y librewolf
rm -f /etc/yum.repos.d/librewolf.repo
dnf config-manager addrepo \
--from-repofile=https://packages.freedom.press/yum-tools-prod/dangerzone/dangerzone.repo
dnf install --setopt=install_weak_deps=False -y dangerzone
rm -f /etc/yum.repos.d/dangerzone.repo
dnf install --setopt=install_weak_deps=False -y \
opendoas \
dash \
fish \
distrobox \
fastfetch \
gamescope \
gamemode \
wine \
alacritty \
dnf clean all
echo "RPM setup complete. Temporary repos cleaned up."
