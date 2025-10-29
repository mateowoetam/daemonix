
[![Build container image](https://github.com/DXC-0/daemonix/actions/workflows/build.yml/badge.svg)](https://github.com/DXC-0/daemonix/actions/workflows/build.yml)

<h1 align="center">
    <img align="center" width=150 src="icon.png" />
    <br><br>
    Daemonix
</h1>
<p align="center">
  <strong>bootc image</strong>
</p>
<p align="center">
   - Universal Blue supercharged by Nix - </i>
</p>

## 📖 Description

- Custom Image, based on [ublue-os/kinoite-main](https://github.com/ublue-os/main)
- [Nix package manager](https://nixos.org/) included by default (nix-shell, déclarative configs...)
- Obtain more than 120 000 packages with [nixpkgs](https://search.nixos.org/packages)
- Fedora Atomic Base with Selinux activated
- Developpement Stuff (podman, docker, vscode, ghostty ...)
- Install and use any linux binary with native [distrobox](https://distrobox.it/)
- Manage apps with [discover](https://apps.kde.org/fr/discover/) and [nix-software-center](https://github.com/snowfallorg/nix-software-center)

## Advantages over classic Fedora

- Isolated applications with [flatpak](https://docs.flatpak.org/en/latest/basic-concepts.html)
- [Cloud-Native](https://en.wikipedia.org/wiki/Cloud-native_computing) immutable spin powered by [bootc](https://github.com/bootc-dev/bootc)
- Rock solid stable with fresh packets
- Latest Nvidia Drivers
- Easy rollback and rebase
- [RPM-fusion](https://rpmfusion.org/) enabled by default
- [Flathub](https://flathub.org/en/about) enabled by default
- Multimedia Codecs

## Installation

> **Note** : This image is designed for my personnal usage, contact me if you want to adapt.  

Rebase from any Fedora Atomic based distro :

```
sudo rpm-ostree rebase --experimental ostree-unverified-registry:ghcr.io/DXC-0/daemonix:latest
```

To use any additionnal feature use : 

```
daemonix-helper
```

[![Copie-d-ecran-20251029-080825.png](https://i.postimg.cc/NjLZfJHy/Copie-d-ecran-20251029-080825.png)](https://postimg.cc/JsVppQKm)

Manually add nixpkgs unstable channel : 

```
nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
nix-channel --update
```

Documentation : [Nix-Determinate](https://docs.determinate.systems/determinate-nix/), [Homemanager](https://nix-community.github.io/home-manager/), [Flakes](https://zero-to-nix.com/concepts/flakes/)  

-----

- Special Thanks to [#Universal-Blue](https://github.com/ublue-os) and their efforts to improve Linux Desktop.
- Thanks to [#Fedora](https://fedoraproject.org/fr/) and the [#atomic-project](https://fedoramagazine.org/introducing-fedora-atomic-desktops/) upstream
- If you have time, check out [#Bluefin](https://projectbluefin.io/) or [#Bazzite](https://bazzite.gg/) and support them.
