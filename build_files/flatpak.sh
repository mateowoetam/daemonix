#!/bin/sh
set -eu
flatpak remote-add --if-not-exists \
flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak config --set languages '*'
flatpak config --set locales '*'
for app in \
org.fkoehler.KTailctl \
org.gnome.DejaDup \
org.kde.haruna \
org.mozilla.firefox;do
if flatpak info "$app" >/dev/null 2>&1;then
flatpak remove -y "$app"
fi
done
flatpak install -y --noninteractive flathub \
io.github.kolunmi.Bazaar \
io.github.flattool.Warehouse \
com.belmoussaoui.Authenticator \
org.libreoffice.LibreOffice \
org.kde.elisa \
org.videolan.VLC
flatpak uninstall --unused -y||true
rm -rf /var/tmp/* /tmp/*
