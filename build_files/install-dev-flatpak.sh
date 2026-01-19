#!/usr/bin/env bash

wget https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-latest.flatpak

flatpak -y install flathub \
com.ranfdev.DistroShelf \
io.github.dvlv.boxbuddyrs \
org.virt_manager.virt-manager \
./hytale-launcher-latest.flatpak

flatpak -y remove flathub \
org.fkoehler.KTailctl \
org.gnome.DejaDup \
org.kde.haruna \
org.mozzilla.firefox

