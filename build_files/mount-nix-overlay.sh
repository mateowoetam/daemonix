#!/usr/bin/bash
set -e

if ! lsmod | grep -q overlay; then
    modprobe overlay || {
        exit 1
    }
fi

mount -t overlay overlay \
  -o lowerdir=/usr/share/nix-store,upperdir=/var/lib/nix-store,workdir=/var/cache/nix-store \
  /nix
