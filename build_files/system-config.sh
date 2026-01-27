#!/bin/sh
set -eu
cat >/etc/doas.conf <<'EOF'
permit setenv { SSH_AUTH_SOCK TERMINFO TERMINFO_DIRS } :wheel
permit nopass keepenv root
EOF
rm -f /etc/dnf/protected.d/sudo.conf
echo doas >/etc/dnf/protected.d/doas.conf
ln -sf /bin/doas /bin/sudo
[ -x /bin/dash ]&&ln -sf /bin/dash /bin/sh
BASE_URL="https://codeberg.org/mateowoetam/fedoramods/raw/branch/main/etc/profile.d"
echo "Installing profile scripts into /etc/profile.d..."
curl -fsSL "$BASE_URL/lang.sh" -o /etc/profile.d/lang.sh
curl -fsSL "$BASE_URL/PackageKit.sh" -o /etc/profile.d/PackageKit.sh
chmod 644 /etc/profile.d/lang.sh /etc/profile.d/PackageKit.sh
rm -rf /root/.cache /root/.cache/curl /var/tmp/*
echo "System configuration complete."
