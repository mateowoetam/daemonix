#!/usr/bin/env bash
set -e

apps=(
  org.fkoehler.KTailctl
  org.gnome.DejaDup
  org.kde.haruna
  org.mozilla.firefox
)

installed=$(flatpak list --app --columns=application)

for app in "${apps[@]}"; do
  if echo "$installed" | grep -qx "$app"; then
    flatpak -y uninstall "$app"
  fi
done
