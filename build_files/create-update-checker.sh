#!/bin/bash

# Service

cat << 'EOF' > /etc/systemd/system/update-checker.service
[Unit]
Description=Booct update checker

[Service]
Type=oneshot
ExecStart=/usr/bin/update-checker.sh

EOF

# Timer

cat << 'EOF' > /etc/systemd/system/update-checker.timer
[Unit]
Description=Run update-checker every hour

[Timer]
OnBootSec=10min
OnUnitActiveSec=1h
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Permissions

chmod +x /usr/bin/update-checker.sh

# Enable service

systemctl enable update-checker.timer
