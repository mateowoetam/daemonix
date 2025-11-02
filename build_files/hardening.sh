#!/bin/bash

### General Hardening

# Firejail for librewolf

echo 'export PATH="/usr/local/bin:$PATH"' > /etc/profile.d/firejail-path.sh
chmod +x /etc/profile.d/firejail-path.sh

sed -i 's|^Exec=.*|Exec=firejail /usr/bin/librewolf|' /usr/share/applications/librewolf.desktop

# Remove undesired suid binaries

chmod 000 /usr/bin/pkexec
chmod 000 /usr/bin/su

# Changing dns resolver 

#ln -sf /run/NetworkManager/resolv.conf /etc/resolv.conf

# Firewalld block in default

firewall-cmd --set-default-zone=block

### Attack surface reduction

# Disable sssd

systemctl disable sssd.service
systemctl mask sssd.service

systemctl disable sssd-kcm.service
systemctl mask sssd-kcm.service

systemctl disable sssd-kcm.socket
systemctl mask sssd-kcm.socket

# Disable geoclue

systemctl disable geoclue.service
systemctl mask geoclue.service

# Disable cups

systemctl disable cups.socket
systemctl mask cups.socket

systemctl disable cups.service
systemctl mask cups.service

systemctl disable cups-browsed.service
systemctl mask cups-browsed.service

# Disable modem manager

systemctl disable ModemManager.service
systemctl mask ModemManager.service

# Disable systemd-resolved

#systemctl disable systemd-resolved.service
#systemctl mask systemd-resolved.service

# Disable NFS daemon

systemctl disable nfs-idmapd.service
systemctl mask nfs-idmapd.service

systemctl disable nfs-client.target
systemctl mask nfs-client.target

systemctl disable nfs-blkmap.service
systemctl mask nfs-blkmap.service

systemctl disable nfs-mountd.service
systemctl mask nfs-mountd.service

systemctl disable nfsdcld.service
systemctl mask nfsdcld.service

systemctl disable nfs-server.service
systemctl mask nfs-server.service

systemctl disable nfs-utils.service
systemctl mask nfs-utils.service

systemctl disable rpc-gssd.service
systemctl mask rpc-gssd.service

systemctl disable rpc-statd-notify.service
systemctl mask rpc-statd-notify.service

systemctl disable rpc-statd.service
systemctl mask rpc-statd.service

systemctl disable rpcbind.service
systemctl mask rpcbind.service

systemctl disable rpcbind.socket
systemctl mask rpcbind.socket

systemctl disable rpcbind.target
systemctl mask rpcbind.target

systemctl disable rpc_pipefs.target

systemctl disable gssproxy.service
systemctl mask gssproxy.service

# Disable Avahi

systemctl disable avahi-daemon.socket
systemctl mask avahi-daemon.socket

systemctl disable avahi-daemon.service
systemctl mask avahi-daemon.service

# Disable Alsa

systemctl disable alsa-state.service
systemctl mask alsa-state.service

# Disable coreos-migration

systemctl disable coreos-container-signing-migration-motd.service

# Disable unconfined rootfull services

systemctl disable uresourced.service
systemctl mask uresourced.service

systemctl disable low-memory-monitor.service
systemctl mask low-memory-monitor.service
