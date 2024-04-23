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
4. Set up games:
      * ``` bash
        mkdir -p /home/keenan/Games/{quake/quake-1,quake/quake-3,RCT,morrowind,blake-stone/aog,blake-stone/ps,jagged-alliance-2/ja2,jagged-alliance-2/unfinished-business,jagged-alliance-2/wildfire,loco,arx-fatalis}
        mkdir -p /home/keenan/.var/app/org.openjkdf2.OpenJKDF2/data/OpenJKDF2/openjkdf2
        mkdir -p '/home/keenan/.var/app/tk.deat.Jazz2Resurrection/data/Jazz² Resurrection/Source'
        mkdir -p /home/keenan/.var/app/io.itch.tx00100xt.SeriousSamClassic-VK/data/Serious-Engine/{serioussam,serioussamse}
        ```
      * `, innoextract -g '/mnt/crusader/Games/Other/GOG/quake_the_offering_game/setup_quake_the_offering_2.0.0.6.exe' -d /home/keenan/Games/quake/quake-1`
      * `, innoextract -g '/mnt/crusader/Games/Other/GOG/quake_iii_arena_and_team_arena/setup_quake3_2.0.0.2.exe' -d /home/keenan/Games/quake/quake-3`
      * `, innoextract -g '/mnt/crusader/Games/Other/GOG/rollercoaster_tycoon_deluxe/setup_rollercoaster_tycoon_deluxe_1.20.015_(17822).exe' -d /home/keenan/Games/RCT`
      * `, innoextract -g '/mnt/crusader/Games/Other/GOG/the_elder_scrolls_iii_morrowind_goty_edition_game/setup_tes_morrowind_goty_2.0.0.7.exe' -d /home/keenan/Games/morrowind`
      * `, innoextract -g '/mnt/crusader/Games/Other/GOG/blake_stone_aliens_of_gold/setup_blake_stone_-_aliens_of_gold_1.0_(28043).exe' -d /home/keenan/Games/blake-stone/aog`
      * `, innoextract -g '/mnt/crusader/Games/Other/GOG/blake_stone_planet_strike/setup_blake_stone_-_planet_strike_1.01_(28043).exe' -d /home/keenan/Games/blake-stone/ps`
      * `, innoextract -g '/mnt/crusader/Games/Other/GOG/jagged_alliance_2/setup_jagged_alliance_2_1.12_(17794).exe' -d /home/keenan/Games/jagged-alliance-2/ja2`
      * `, innoextract -g '/mnt/crusader/Games/Other/GOG/jagged_alliance_2_unfinished_business/setup_ja2_-_unfinished_business_1.01_(17724).exe' -d /home/keenan/Games/jagged-alliance-2/unfinished-business`
      * `, innoextract -g '/mnt/crusader/Games/Other/GOG/jagged_alliance_2_wildfire/setup_jagged_alliance_2_wildfire_6.08_(16760).exe' -d /home/keenan/Games/jagged-alliance-2/wildfire`
      * `, innoextract -g '/mnt/crusader/Games/Other/GOG/xcom_ufo_defense/setup_x-com_ufo_defense_1.2_(28046).exe' -d /home/keenan/.local/share/openxcom/UFO`
      * `, innoextract -g '/mnt/crusader/Games/Other/GOG/xcom_terror_from_the_deep/setup_x-com_terror_from_the_deep_2.1_(28046).exe' -d /home/keenan/.local/share/openxcom/TFTD`
      * `, innoextract -g '/mnt/crusader/Games/Other/GOG/star_wars_dark_forces/setup_star_warstm_dark_forces_1.0.2_(20338).exe' -d /home/keenan/.var/app/io.github.theforceengine.tfe/data`
      * `, innoextract -L -g '/mnt/crusader/Games/Other/GOG/stalker_shadow_of_chernobyl/setup_stalker_shoc_2.1.0.7.exe' -d '/home/keenan/.local/share/GSC Game World/S.T.A.L.K.E.R. - Call of Pripyat' && mv '/home/keenan/.local/share/GSC Game World/S.T.A.L.K.E.R. - Call of Pripyat/game/'* '/home/keenan/.local/share/GSC Game World/S.T.A.L.K.E.R. - Call of Pripyat' && rm -rf '/home/keenan/.local/share/GSC Game World/S.T.A.L.K.E.R. - Call of Pripyat/'{__unpacker,app,DirectX,Foxit,support,tmp}`
      * `, innoextract -g '/mnt/crusader/Games/Other/GOG/chris_sawyers_locomotion/setup_chris_sawyers_locomotion_4.02.176_(22259).exe' -d /home/keenan/Games/loco`
      * `, innoextract -g '/mnt/crusader/Games/Other/GOG/arx_fatalis/setup_arx_fatalis_1.22_(38577).exe' -d /home/keenan/Games/arx-fatalis`
      * `, innoextract -g '/mnt/crusader/Games/Other/GOG/star_wars_jedi_knight_ii_jedi_outcast/setup_star_wars_jedi_knight_ii_-_jedi_outcast_1.04_(17964).exe' -d '/home/keenan/.local/share/openjo/base'`
      * `, innoextract -g '/mnt/crusader/Games/Other/GOG/star_wars_jedi_knight_jedi_academy/setup_star_wars_jedi_knight_-_jedi_academy_1.01_(a)_(10331).exe' -d '/home/keenan/.local/share/openjk/base'`
      * `, innoextract -g '/mnt/crusader/Games/Other/GOG/doom_3_classic/setup_doom_3_1.3.1_(62814).exe' -d '/home/keenan/.var/app/org.dhewm3.Dhewm3/data/dhewm3'`
      * `, innoextract -g '/mnt/crusader/Games/Other/GOG/doom_3_bfg_edition_game/setup_doom_3_bfg_1.14_(13452).exe' -d /home/keenan/.local/share/rbdoom3bfg && mv /home/keenan/.local/share/rbdoom3bfg/app/* /home/keenan/.local/share/rbdoom3bfg && rm -rf /home/keenan/.local/share/rbdoom3bfg/tmp /home/keenan/.local/share/rbdoom3bfg/app`
      * `, innoextract -g '/mnt/crusader/Games/Other/GOG/doom_64/setup_doom_64_20220523_(56385).exe' -I 'DOOM64.WAD' -d '/home/keenan/.local/share/doom64ex-plus/'`
      * `, innoextract -g /mnt/crusader/Games/Other/GOG/fallout_game/setup_fallout_1.2_\(27130\).exe -d /home/keenan/.local/share/fallout-ce && cd /home/keenan/.local/share/fallout-ce && rm -rf __redist __support app commonappdata Extras tmp goggame* && pwsh -c 'dir . -r | % { if ($_.Name -cne $_.Name.ToLower()) { ren $_.FullName $_.Name.ToLower() } }' && cd /home/keenan/.local/share/fallout-ce/data/sound/music && pwsh -c 'dir . -r | % { if ($_.Name -cne $_.Name.ToUpper()) { ren $_.FullName $_.Name.ToUpper() } }' && gamescope -f -w 2560 -h 1440 -- fallout-ce && sleep 3 && sd 'music_path1=sound\\music\\' 'music_path1=data\\sound\\music\\' /home/keenan/.local/share/fallout-ce/fallout.cfg && sd 'music_path2=sound\\music\\' 'music_path2=data\\sound\\music\\' /home/keenan/.local/share/fallout-ce/fallout.cfg`
      * `, innoextract -g /mnt/crusader/Games/Other/GOG/fallout_2_game/setup_fallout2_2.1.0.18.exe -d /home/keenan/.local/share/fallout2-ce && cd /home/keenan/.local/share/fallout2-ce && mv -f app/* . && rm -rf __redist __support app commonappdata Extras tmp goggame* && mv -f sound/ data/ && pwsh -c 'dir . -r | % { if ($_.Name -cne $_.Name.ToLower()) { ren $_.FullName $_.Name.ToLower() } }' && cd /home/keenan/.local/share/fallout2-ce/data/sound/music && pwsh -c 'dir . -r | % { if ($_.Name -cne $_.Name.ToUpper()) { ren $_.FullName $_.Name.ToUpper() } }' && gamescope -f -w 2560 -h 1440 -- fallout2-ce && sleep 3 && sd 'music_path1=sound\\music\\' 'music_path1=data\\sound\\music\\' /home/keenan/.local/share/fallout2-ce/fallout2.cfg && sd 'music_path2=sound\\music\\' 'music_path2=data\\sound\\music\\' /home/keenan/.local/share/fallout2-ce/fallout2.cfg`
      * `, innoextract -g '/mnt/crusader/Games/Other/GOG/diablo/setup_diablo_1.09_hellfire_v2_(30038).exe' -I 'DIABDAT.MPQ' -I 'hellfire.mpq' -I 'hfmonk.mpq' -I 'hfmusic.mpq' -I 'hfvoice.mpq' -d /home/keenan/.var/app/org.diasurgical.DevilutionX/data/diasurgical/devilution && mv /home/keenan/.var/app/org.diasurgical.DevilutionX/data/diasurgical/devilution/hellfire/* /home/keenan/.var/app/org.diasurgical.DevilutionX/data/diasurgical/devilution && rm -rf /home/keenan/.var/app/org.diasurgical.DevilutionX/data/diasurgical/devilution/hellfire`
      * `, innoextract -g '/mnt/crusader/Games/Other/GOG/star_wars_jedi_knight_dark_forces_ii_copy3/setup_star_wars_jedi_knight_-_mysteries_of_the_sith_1.0_(17966).exe' -d /home/keenan/.var/app/org.openjkdf2.OpenJKDF2/data/OpenJKDF2/openjkdf2 && mv /home/keenan/.var/app/org.openjkdf2.OpenJKDF2/data/OpenJKDF2/openjkdf2/app/* /home/keenan/.var/app/org.openjkdf2.OpenJKDF2/data/OpenJKDF2/openjkdf2 && , innoextract -g '/mnt/crusader/Games/Other/GOG/star_wars_republic_commando_copy3/setup_star_wars_jedi_knight_-_dark_forces_2_1.01_(17966).exe' -d /home/keenan/.var/app/org.openjkdf2.OpenJKDF2/data/OpenJKDF2/openjkmots && mv /home/keenan/.var/app/org.openjkdf2.OpenJKDF2/data/OpenJKDF2/openjkmots/app/* /home/keenan/.var/app/org.openjkdf2.OpenJKDF2/data/OpenJKDF2/openjkmots`
      * `, innoextract -g '/mnt/crusader/Games/Other/GOG/jazz_jackrabbit_2_secret_files/extras/setup_jazz_jackrabbit_2_1.24_jj2_(5.11)_(62338).exe' -d '/home/keenan/.var/app/tk.deat.Jazz2Resurrection/data/Jazz² Resurrection/Source' && , innoextract -g '/mnt/crusader/Games/Other/GOG/jazz_jackrabbit_2_christmas_chronicles/setup_jazz_jackrabbit_2_cc_1.2x_(16742).exe' -d '/home/keenan/.var/app/tk.deat.Jazz2Resurrection/data/Jazz² Resurrection/Source' && cd '/home/keenan/.var/app/tk.deat.Jazz2Resurrection/data/Jazz² Resurrection/Source' && rm -rf __redist __support app commonappdata tmp`
      * `, innoextract -g '/mnt/crusader/Games/Other/GOG/serious_sam_the_first_encounter/setup_serious_sam_the_first_encounter_1.05_(21759).exe' -d /home/keenan/.var/app/io.itch.tx00100xt.SeriousSamClassic-VK/data/Serious-Engine/serioussam && , innoextract -g '/mnt/crusader/Games/Other/GOG/serious_sam_the_second_encounter/setup_serious_sam_the_second_encounter_1.07_(21759).exe' -d /home/keenan/.var/app/io.itch.tx00100xt.SeriousSamClassic-VK/data/Serious-Engine/serioussamse`
### Server
1. Log into GOG and Internet Archive
    * `lgogdownloader`
    * `ia login`