#!/bin/bash

declare -A scripts=(
  ["1"]="dev_mode"
  ["2"]="update_system"
  ["3"]="flatpak_update"
  ["4"]="hytale_install"
  ["5"]="update_nix"
  ["6"]="enable_unstable"
  ["7"]="enable_unfree"
  ["8"]="nix_list"
  ["9"]="nix_garbage"
)

dev_mode() {
 bash dev-mode
 echo "developer mode enabled"
 sleep 3
}

flatpak_update() {
 flatpak update
 echo "flatpak applications updated"
 sleep 3
}

hytale_install() {
 bash hytale-install
 echo "Hytale flatpak installed"
 sleep 3
}

update_system() {
  rpm-ostree update && rpm-ostree upgrade
  echo "system updated, please reboot"
  sleep 3
}

update_nix() {
  nix-channel --update
  echo "nix channels updated"
  sleep 3
}

enable_unstable() {
  nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
  nix-channel --update
  echo "unstable nixpkgs enabled"
  sleep 3
}

enable_unfree() {
  rm -rf ~/.config/nixpkgs
  mkdir -p ~/.config/nixpkgs
  echo '{ allowUnfree = true; }' > ~/.config/nixpkgs/config.nix
  echo "nix unfree package enabled"
  sleep 3
}

nix_list() {
  nix profile list
  echo "installed packages"
  read
}

nix_garbage() {
  nix-collect-garbage -d
  echo "old nix generation deleted"
  sleep 3
}


while true; do
  echo
  echo "============== DAEMONIX HELPER ==============="
  echo
  echo "This menu lets you easily activate image features."
  echo
  echo "--> This image is immutable and designed for developers."
  echo "--> Ideal for container workflows and reproducible environments."
  echo
  echo "Documentation: https://github.com/DXC-0/daemonix/"
  echo "Report bugs: https://github.com/DXC-0/daemonix/issues"
  echo
  echo "--> Nix is pre-installed. Just type 'nix' in your terminal ;)"
  echo "--> Search packages : https://search.nixos.org/packages"
  echo "--> Documentation : https://wiki.nixos.org/wiki/NixOS_Wiki"
  echo
  echo "AVAILABLE OPTIONS :"
  echo
  echo "1) Activate Developer Mode"
  echo "2) Update the system"
  echo "3) Update flatpaks"
  echo "4) Install Hytale"
  echo "5) Update nix channels"
  echo "6) Enable nixpkgs unstable"
  echo "7) Enable nix unfree packages"
  echo "8) List installed nix packages"
  echo "9) Run nix garbage"
  echo
  echo
  read -rp "Select an option: " choice

  if [[ "$choice" == "q" ]]; then
    echo "Thanks for using Daemonix. Goodbye!"
    break
  elif [[ -n "${scripts[$choice]}" ]]; then
    echo "Running: ${scripts[$choice]}..."
    "${scripts[$choice]}"
    echo "Done "
  else
    echo "Bad choice"
  fi
  echo
done
