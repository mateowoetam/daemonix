#!/bin/sh
set -e

apps='
org.fkoehler.KTailctl
org.gnome.DejaDup
org.kde.haruna
org.mozilla.firefox
'

installed=$(flatpak list --app --columns=application)

echo "$apps" | while IFS= read -r app; do
    [ -z "$app" ] && continue

    if echo "$installed" | grep -qx "$app"; then
        flatpak -y uninstall "$app"
    fi
done
