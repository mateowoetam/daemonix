#!/bin/sh
set -eu
FEDORA_VERSION=$(rpm -E %fedora)
DNF_OPTS="--setopt=tsflags=nodocs --setopt=install_weak_deps=False"
dnf remove -y \
firefox htop nvtop kfind krfb kcharselect kde-connect \
kwalletmanager kdebugsettings plasma-discover okular fcitx5||true
dnf install -y $DNF_OPTS \
"https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$FEDORA_VERSION.noarch.rpm" \
"https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$FEDORA_VERSION.noarch.rpm"
dnf install -y $DNF_OPTS \
libavcodec-freeworld \
VK_hdr_layer \
opendoas dash fish fastfetch gamescope wine alacritty
dnf config-manager addrepo \
--from-repofile=https://repo.librewolf.net/librewolf.repo
dnf install -y $DNF_OPTS librewolf
rm -f /etc/yum.repos.d/librewolf.repo
dnf config-manager addrepo \
--from-repofile=https://packages.freedom.press/yum-tools-prod/dangerzone/dangerzone.repo
dnf install -y $DNF_OPTS dangerzone
rm -f /etc/yum.repos.d/dangerzone.repo
dnf remove -y rpmfusion-free-release rpmfusion-nonfree-release||true
rm -f /etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion*
dnf clean all
rm -rf /var/cache/dnf /var/lib/dnf /var/tmp/*
