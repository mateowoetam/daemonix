#!/usr/bin/bash
set -e

mount -t overlay overlay \
  -o lowerdir=/usr/share/nix-store,upperdir=/var/lib/nix-store,workdir=/var/cache/nix-store \
  /nix
