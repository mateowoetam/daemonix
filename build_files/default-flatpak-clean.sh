#!/usr/bin/env bash
set -e

flatpak -y uninstall \
  org.fkoehler.KTailctl \
  org.gnome.DejaDup \
  org.kde.haruna \
  org.mozilla.firefox
