#!/usr/bin/env bash
# Remove old NixOS generations and garbage-collect the Nix store.
# Usage:
#   source /home/honor/nix-configurations/scripts/remove-cache.sh
#
# Keep the last N days of generations (default 7):
#   KEEP_DAYS=30 source /home/honor/nix-configurations/scripts/remove-cache.sh

set -uo pipefail

keep="${KEEP_DAYS:-7}"

echo ":: Listing current generations before cleanup:"
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

echo ""
echo ":: Removing system generations older than ${keep} days..."
sudo nix-env --delete-generations +"${keep}d" --profile /nix/var/nix/profiles/system

echo ""
echo ":: Removing user generations older than ${keep} days..."
nix-env --delete-generations +"${keep}d"
home-manager expire-generations "-${keep} days" 2>/dev/null || true

echo ""
echo ":: Garbage-collecting the Nix store..."
sudo nix-collect-garbage --delete-older-than "${keep}d"
nix-collect-garbage --delete-older-than "${keep}d"

echo ""
echo ":: Done. Current generations:"
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

echo ""
df -h / | head -2
