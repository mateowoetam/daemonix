#!/bin/bash

USER_NAME=$(loginctl list-users | tail -n +2 | awk '$2 != "root" {print $2}' | head -n 1)
USER_ID=$(id -u "$USER_NAME")
XDG_RUNTIME_DIR="/run/user/$USER_ID"
DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
DISPLAY=":0"

CHECK_UPDATE=$(bootc upgrade --check)
pattern="Update available|Upgrade available"

if echo "$CHECK_UPDATE" | grep -qE "$pattern"; then
    sudo -u "$USER_NAME" \
        DISPLAY=$DISPLAY \
        DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS \
        kdialog --title "Update check" --passivepopup "Updates are available!" 10
fi
