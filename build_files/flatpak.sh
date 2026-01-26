#!/bin/sh
set -eu

# Enable Flathub (kept enabled intentionally)
flatpak remote-add --if-not-exists \
    flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# remove unwanted Flatpaks
flatpak remove -y \
    org.fkoehler.KTailctl \
    org.gnome.DejaDup \
    org.kde.haruna \
    org.mozilla.firefox \

# add wanted Flatpaks
flatpak install -y \
    io.github.kolunmi.Bazaar
