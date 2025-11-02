#!/usr/bin/bash
set -e

mkdir -p /usr/share/nix-store      
mkdir -p /var/lib/nix-store        
mkdir -p /var/cache/nix-store      
mkdir -p /nix

mount -t overlay overlay \
  -o lowerdir=/usr/share/nix-store,upperdir=/var/lib/nix-store,workdir=/var/cache/nix-store \
  /nix
