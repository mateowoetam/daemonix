#!/bin/bash

dnf install -y https://nix-community.github.io/nix-installers/nix/x86_64/nix-multi-user-2.24.10.rpm

if [ -d /nix/store ]; then
  mv /nix/* /usr/share/nix-store/
fi
