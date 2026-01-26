#!/bin/sh
set -eu
flatpak remote-add --if-not-exists \
flathub https://dl.flathub.org/repo/flathub.flatpakrepo
for flatpak in org.fkoehler.KTailctl org.gnome.DejaDup org.kde.haruna org.mozilla.firefox;do
if flatpak list --app|grep -q "$flatpak";then
flatpak remove -y "$flatpak"
fi
done
flatpak install -y \
io.github.kolunmi.Bazaar
