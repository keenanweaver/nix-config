# Installation instructions

Prerequisites: 
* Disable Secure Boot

## Bare-metal
1. Download NixOS ISO & mount on machine
2. Delete some stuff: `sudo su && rm -rf /etc/nixos /etc/NIXOS && mkdir -p /etc/nixos`
3. Clone this repo to the machine: 
    * `nix --experimental-features "nix-command flakes" run nixpkgs#git -- clone https://github.com/keenanweaver/nix-config.git /etc/nixos/.`
4. Partition the disks:
    * `nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /etc/nixos/hosts/desktop/disko.nix`
    * `nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /etc/nixos/hosts/laptop/disko.nix`
    * `nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /etc/nixos/hosts/pi/disko.nix`
    * `nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /etc/nixos/hosts/vm/disko.nix`
5. Verify hardware-configuration.nix disk IDs, add to repo hardware-configuration.nix: 
   * `nixos-generate-config --root /mnt`
6. If necessary, comment out nix-nonfree flake/import.
7.  Enter nix-shell: 
    * `nix-shell --experimental-features "nix-command flakes" -p git`
8. Set up Secure Boot keys:
    1.  Verify ESP is mounted at /boot: `bootctl status`
    2.  Create keys: `sudo sbctl create-keys`
9.  Install: 
    * `nixos-install --flake .#nixos-desktop`
    * `nixos-install --flake .#nixos-laptop`
    * `nixos-install --flake .#nixos-pi`
    * `nixos-install --flake .#nixos-vm`
10. Reboot: `reboot`
11. Finish Secure Boot setup: 
    1.  Rebuild your system and check the sbctl verify output: `sudo sbctl verify`
    2.  Reboot to BIOS and enable Secure Boot. You may need to erase all Secure Boot settings.
    3.  Reboot and enroll the keys: `sudo sbctl enroll-keys --microsoft`
    4.  Reboot and verify Secure Boot is activated: `bootctl status`
## Existing machine
1. Clone this repo to the machine: 
    * `nix run nixpkgs#git -- clone https://github.com/keenanweaver/nix-config.git /etc/nixos/.`
2. Update flake (optional): 
    * `sudo nix flake update /etc/nixos`
3. Apply configuration:
    * `sudo nixos-rebuild switch --impure --upgrade --flake /etc/nixos/#nixos-desktop`
    * `sudo nixos-rebuild switch --impure --upgrade --flake /etc/nixos/#nixos-laptop`
    * `sudo nixos-rebuild switch --impure --upgrade --flake /etc/nixos/#nixos-pi`
    * `sudo nixos-rebuild switch --impure --upgrade --flake /etc/nixos/#nixos-vm`

## Post-install manual steps

1. Copy private SSH keys & secrets to ~/.ssh and ~/.config/sops/age respectively.
2. Set up ~/.config/nix.conf with private GitHub token for nix-nonfree repo: `access-tokens = github.com=ghp_blahblahblah`
3. Initialize ssh-agent: `ssh-add ~/.ssh/id_ed25519 && ssh-add -l`
4. Run `nixos-rebuild switch`

### Desktop/laptop
Run `bootstrap-baremetal.sh`
<br />or
1. Set up distrobox containers:
    * `distrobox create assemble`
    * `distrobox enter bazzite-arch-exodos -- bash -l -c "/home/keenan/.config/distrobox/bootstrap-bazzite-arch-exodos.sh"`
    * `distrobox enter bazzite-arch-gaming -- bash -l -c "/home/keenan/.config/distrobox/bootstrap-bazzite-arch-gaming.sh"`
    * `distrobox enter bazzite-arch-sys -- bash -l -c "/home/keenan/.config/distrobox/bootstrap-bazzite-arch-sys.sh"`
2. Set up flatpaks:
    * `flatpak-install-all.sh`
    <br />or<br />
    * `flatpak-install-sys.sh && flatpak-install.sh && flatpak-install-games.sh`
3. Download other things:
    * Conty:
      * `curl https://api.github.com/repos/Kron4ek/conty/releases/latest | jq -r '.assets[] | select(.name | test("conty_lite.sh$")).browser_download_url' | wget -i- -N -P /home/keenan/.local/bin`
      * `chmod +x /home/keenan/.local/bin/conty_lite.sh`
      * `conty_lite.sh -u`
    * Rustdesk:
      *  `curl https://api.github.com/repos/rustdesk/rustdesk/releases/latest | jq -r '.assets[] | select(.name | test(".*flatpak$")).browser_download_url' | wget -i- -N -P /home/keenan/Downloads`
      *  `fd 'rustdesk' /home/keenan/Downloads -e flatpak -x flatpak install -u -y`
4. Set up games. See [GAMES.md](GAMES.md)
### Server
1. Log into GOG and Internet Archive
    * `lgogdownloader`
    * `ia login`