## notes

- when in Cursor SSH access, grant access to the entire dir: `sudo chown -R honor:users /etc/nixos`
- proxy setup for git push:
  ```bash
  export http_proxy="http://192.168.1.5:1082" && export https_proxy="http://192.168.1.5:1082" && sudo -E git push -u origin main
  ```

## cleanup
```bash
sudo nix-collect-garbage -d && nix-store --optimise
```

## usage
to apply changes to the system (rebuild):

```bash
# apply configuration for 'magicbook' host
nixos-rebuild switch --flake .#magicbook
```

if you are not in this directory:
```bash
sudo nixos-rebuild switch --flake ~/nix-configurations#magicbook
```

## todos
- [ ] better solutions to keys remapping

