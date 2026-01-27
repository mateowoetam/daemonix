#!/bin/sh
set -eu
flatpak remote-add --if-not-exists \
flathub https://dl.flathub.org/repo/flathub.flatpakrepo
for app in \
org.fkoehler.KTailctl \
org.gnome.DejaDup \
org.kde.haruna \
org.mozilla.firefox;do
if flatpak list --app --columns=application|grep "$app";then
flatpak remove -y "$app"
fi
done
flatpak install -y flathub \
io.github.kolunmi.Bazaar \
io.github.flattool.Warehouse \
com.belmoussaoui.Authenticator \
org.libreoffice.LibreOffice \
org.kde.elisa \
org.videolan.VLC
