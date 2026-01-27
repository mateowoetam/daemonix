#!/bin/sh
set -eu
log(){
printf '[nvidia] %s\n' "$*"
}
if [ "${BUILD_FLAVOR:-}" != "nvidia" ];then
log "BUILD_FLAVOR != nvidia, skipping NVIDIA setup"
exit 0
fi
set -x
KERNEL_VERSION="$(ls -1 /usr/lib/modules 2>/dev/null|sort|tail -n 1||true)"
if [ -z "$KERNEL_VERSION" ];then
log "ERROR: No kernel found in /usr/lib/modules"
exit 1
fi
log "Using kernel: $KERNEL_VERSION"
if [ ! -f /etc/yum.repos.d/fedora-nvidia.repo ];then
dnf config-manager addrepo \
--from-repofile=https://negativo17.org/repos/fedora-nvidia.repo
fi
dnf config-manager setopt fedora-nvidia.enabled=0||true
if ! grep -q '^priority=' /etc/yum.repos.d/fedora-nvidia.repo;then
sed -i '/^enabled=/a priority=90' /etc/yum.repos.d/fedora-nvidia.repo
fi
dnf -y install gcc-c++ --setopt=install_weak_deps=False
if ! rpm -q akmod-nvidia >/dev/null 2>&1;then
dnf -y install --enablerepo=fedora-nvidia akmod-nvidia
fi
mkdir -p /var/tmp
chmod 1777 /var/tmp
akmods --force --kernels "$KERNEL_VERSION" --kmod nvidia||true
cat /var/cache/akmods/nvidia/*.failed.log 2>/dev/null||true
dnf -y install --enablerepo=fedora-nvidia \
nvidia-driver \
nvidia-driver-cuda \
libnvidia-fbc \
libva-nvidia-driver \
nvidia-modprobe \
nvidia-persistenced \
nvidia-settings
if [ ! -f /etc/yum.repos.d/nvidia-container-toolkit.repo ];then
dnf config-manager addrepo \
--from-repofile=https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo
fi
dnf config-manager setopt nvidia-container-toolkit.enabled=0||true
if ! rpm -q nvidia-container-toolkit >/dev/null 2>&1;then
dnf -y install --enablerepo=nvidia-container-toolkit nvidia-container-toolkit
fi
if command -v semodule >/dev/null 2>&1;then
curl -fsSL \
https://raw.githubusercontent.com/NVIDIA/dgx-selinux/master/bin/RHEL9/nvidia-container.pp \
-o /tmp/nvidia-container.pp||true
semodule -i /tmp/nvidia-container.pp||true
rm -f /tmp/nvidia-container.pp
fi
cat >/usr/lib/modprobe.d/00-nouveau-blacklist.conf <<'EOF'
blacklist nouveau
options nouveau modeset=0
EOF
mkdir -p /usr/lib/bootc/kargs.d
cat >/usr/lib/bootc/kargs.d/00-nvidia.toml <<'EOF'
kargs = [
  "rd.driver.blacklist=nouveau",
  "modprobe.blacklist=nouveau",
  "nvidia-drm.modeset=1"
]
EOF
if [ -f /usr/lib/dracut/dracut.conf.d/99-nvidia.conf ];then
sed -i 's/omit_drivers/force_drivers/g' \
/usr/lib/dracut/dracut.conf.d/99-nvidia.conf
sed -i 's/ nvidia / i915 amdgpu nvidia /g' \
/usr/lib/dracut/dracut.conf.d/99-nvidia.conf
fi
if [ -f /etc/modprobe.d/nvidia-modeset.conf ];then
mv -f /etc/modprobe.d/nvidia-modeset.conf /usr/lib/modprobe.d/
fi
cat >/usr/lib/systemd/system/nvctk-cdi.service <<'EOF'
[Unit]
Description=NVIDIA container toolkit CDI auto-generation
ConditionFileIsExecutable=/usr/bin/nvidia-ctk
After=local-fs.target

[Service]
Type=oneshot
ExecStart=/usr/bin/nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml

[Install]
WantedBy=multi-user.target
EOF
systemctl enable nvctk-cdi.service 2>/dev/null||true
