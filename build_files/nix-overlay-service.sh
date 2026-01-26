#!/bin/sh
mkdir -p /usr/share/nix-store
mkdir -p /var/lib/nix-store
mkdir -p /var/cache/nix-store
mkdir -p /nix
echo overlay >/etc/modules-load.d/overlay.conf
cat <<'EOF' >/etc/systemd/system/nix-overlay.service
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
chmod +x /usr/bin/mount-nix-overlay.sh
systemctl enable nix-overlay.service
