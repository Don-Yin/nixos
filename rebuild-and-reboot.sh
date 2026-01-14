#!/usr/bin/env bash
# Source this script to rebuild and reboot immediately.
# Usage:
#   source /home/honor/nix-configurations/rebuild-and-reboot.sh
#
# Optional:
#   NO_REBOOT=1 source /home/honor/nix-configurations/rebuild-and-reboot.sh

set -uo pipefail

repo="/home/honor/nix-configurations"
flake="${repo}#magicbook"

cd "$repo"

is_sourced=0
if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
  is_sourced=1
fi

if sudo nixos-rebuild switch --flake "$flake"; then
  :
else
  rc=$?
  echo "rebuild-and-reboot: nixos-rebuild failed (exit $rc). Not rebooting." >&2
  echo "rebuild-and-reboot: fix the error above, then re-run: source ${repo}/rebuild-and-reboot.sh" >&2
  if [[ "$is_sourced" = "1" ]]; then
    return "$rc"
  else
    exit "$rc"
  fi
fi

if [[ "${NO_REBOOT:-0}" != "1" ]]; then
  sudo reboot
fi

