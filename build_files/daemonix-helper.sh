#!/bin/bash

declare -A scripts=(
  ["1"]="dev-mode"
  ["2"]="com-tools"
  ["3"]="gaming-extra"
)

while true; do
  echo
  echo "============== DAEMONIX HELPER ============"
  echo
  echo
  echo This menu allows you to easily activate image features.
  echo
  echo "--> This image is immutable and intended primarily for developers"
  echo "--> Focused on container-oriented workflows and reproducibility tasks"
  echo         
  echo For more help, read the documentation at : https://github.com/DXC-0/daemonix/
  echo
  echo For bugs open an issue : https://github.com/DXC-0/daemonix/issues
  echo
  echo "--> Nix is directly included, to use it, write nix in your terminal ;)"
  echo "--> To check packages avaibility: https://search.nixos.org/packages"
  echo "--> Documentation : https://wiki.nixos.org/wiki/NixOS_Wiki/fr"
  echo
  echo "AVAILABLES OPTIONS :"
  echo
  echo "1) Activate Developper Mode"
  echo "2) Install communication tools"
  echo "3) Install extra gaming tools"
  echo "q) Exit"
  echo
  echo
  echo -n "Please, select an option : "
  read -r choice

  if [[ "$choice" == "q" ]]; then
    echo "Thank you for using daemonix! !"
    break
  elif [[ -n "${scripts[$choice]}" ]]; then
    echo "Excution ${scripts[$choice]}..."
    bash "${scripts[$choice]}"
  else
    echo "Bad choice"
  fi
  echo
done
