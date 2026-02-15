## bootstrap (new machine)

```bash
nix-shell -p git git-lfs --run "git lfs install && git clone https://github.com/Don-Yin/nixos.git ~/nix-configurations && sudo nixos-rebuild switch --flake ~/nix-configurations#magicbook"
```

## usage

Apply changes to the system (rebuild):

```bash
# from this directory
sudo nixos-rebuild switch --flake .#magicbook

# from anywhere
sudo nixos-rebuild switch --flake ~/nix-configurations#magicbook

# or use the helper script
NO_REBOOT=1 source ~/nix-configurations/scripts/rebuild-and-reboot.sh
```

## cleanup
remove old generations and garbage-collect the Nix store:

```bash
source ~/nix-configurations/scripts/remove-cache.sh
```

## proxy (China)

```bash
export http_proxy="http://192.168.1.5:1082"
export https_proxy="http://192.168.1.5:1082"
sudo -E git push -u origin main
```

# files
nix-configurations/
├── flake.nix
├── flake.lock
├── README.MD
├── assets/wallpapers/          # Git LFS
├── scripts/
│   ├── rebuild-and-reboot.sh
│   └── remove-cache.sh
├── secrets/
├── hosts/magicbook/
├── modules/
│   ├── desktop/   (apps, font)
│   ├── services/  (openssh, vpn, eduroam)
│   └── system/    (network, timezone, users)  # users.nix moved here
└── home/honor/
    ├── home.nix
    ├── dotfiles/
    ├── configurations/  (hyprland, kitty, waybar, wofi)
    └── services/        (input, session, xremap)