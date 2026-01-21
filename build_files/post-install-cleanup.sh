#!/bin/sh
set -e

# Disable RPMFusion
for repo in rpmfusion-free rpmfusion-nonfree; do
  dnf config-manager setopt "${repo}.enabled=0" || true
done

# Remove LibreWolf repo
rm -f /etc/yum.repos.d/librewolf.repo

# Remove Dangerzone repo
rm -rf /etc/yum.repos.d/dangerzone.repo

dnf autoremove

# (Optional) Disable Flathub
# flatpak remote-modify --disable flathub

echo "Repos cleaned up after build."
