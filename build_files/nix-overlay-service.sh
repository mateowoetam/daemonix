#!/bin/bash

# Preparation

mkdir -p /usr/share/nix-store      
mkdir -p /var/lib/nix-store        
mkdir -p /var/cache/nix-store      
mkdir -p /nix

# Module

echo overlay > /etc/modules-load.d/overlay.conf

# Create systemd service

cat << 'EOF' > /etc/systemd/system/nix-overlay.service
[Unit]
Description=Mount OverlayFS for /nix
DefaultDependencies=no
After=local-fs.target
Before=nix-daemon.service

[Service]
Type=oneshot
ExecStart=/usr/bin/mount-nix-overlay.sh
RemainAfterExit=yes
ConditionPathExists=/usr/bin/mount-nix-overlay.sh

[Install]
WantedBy=multi-user.target
EOF

# Permissions

chmod +x /usr/bin/mount-nix-overlay.sh

# Enable service

systemctl enable nix-overlay.service
