#!/bin/bash

cat << 'EOF' > /etc/systemd/system/update-checker.service
[Unit]
Description=Booct update checker

[Service]
Type=oneshot
ExecStart=/usr/bin/update-checker.sh

[Install]
WantedBy=graphical.target
EOF

# Permissions

chmod +x /usr/bin/update-checker.sh

# Enable service

systemctl enable update-checker.service