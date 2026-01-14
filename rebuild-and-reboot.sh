#!/usr/bin/env bash
# Source this script to rebuild and reboot immediately.
# Usage:
#   source /home/honor/nix-configurations/rebuild-and-reboot.sh
#
# Optional:
#   NO_REBOOT=1 source /home/honor/nix-configurations/rebuild-and-reboot.sh

set -euo pipefail

repo="/home/honor/nix-configurations"
flake="${repo}#magicbook"

cd "$repo"
sudo nixos-rebuild switch --flake "$flake"

if [[ "${NO_REBOOT:-0}" != "1" ]]; then
  sudo reboot
fi

