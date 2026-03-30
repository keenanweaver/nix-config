# Keenan's Nix config

![Screenshot_20250519_100830](https://github.com/user-attachments/assets/37c62f35-fe9a-4fbb-ba36-2b269e9c93b1)

This setup utilizes the following:
* BTRFS with tmpfs root and impermanence, encrypted by LUKS
* 'Modular' setup to keep things clean
* Flakes
* Mild hardening for security
* Performance tweaks
* KDE desktop environment with my preferred theming (Catppuccin) and options

If you fork this and try to use it without modifying anything, you will have a bad time. Here is a list of things you _probably_ want to change if you go this route:
* Username in [flake.nix](flake.nix)
* initialHashedPassword and authorizedKeys in [modules/core/users/default.nix](modules/core/users/default.nix)
* All secrets in [secrets](/secrets/secrets.yaml) (see [sops-nix](https://github.com/Mic92/sops-nix) for instructions)
* My specific stuff in all the modules. Have fun!

My suggestion is to just take the bits and pieces you like and morph them into your own config.

I'm always looking to simplify or make things better. Please let me know if you have suggestions.

TODO:
* Consider [dendritic pattern](https://github.com/Doc-Steve/dendritic-design-with-flake-parts) migration
* Linking Kron4ek Wine breaks [Bottles](modules/apps/bottles/default.nix)

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
    * `nixos-install --flake .#nixos-unraid`
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
    * `sudo nixos-rebuild switch --impure --upgrade --flake /etc/nixos/#nixos-unraid`

## Post-install manual steps

1. Copy private SSH keys & secrets to ~/.ssh and ~/.config/sops/age respectively.
2. Set up ~/.config/nix.conf with private GitHub token for nix-nonfree repo: `access-tokens = github.com=ghp_blahblahblah`
3. Uncomment out nix-nonfree flake input (optional)
4. Initialize ssh-agent: `ssh-add ~/.ssh/id_ed25519 && ssh-add -l`
5. Run `nixos-rebuild switch`

### Desktop/laptop
Run `bootstrap-baremetal.sh`
<br />or
1. Set up distrobox containers:
    * `distrobox create assemble`
    * `distrobox enter exodos -- bash -l -c "bootstrap-distrobox"`
    * `distrobox enter arch-gaming -- bash -l -c "bootstrap-distrobox"`
2. Set up games. See [GAMES.md](GAMES.md)
### Server
1. Log into GOG and Internet Archive
    * `lgogdownloader`
    * `ia configure`

# Setting up games

This is to quickly set up games for nix, Flatpak, and distrobox that require extra data files.

## From bare-metal
1. Run `script-game-stuff`

## Set up games

Enter a nix shell:

``` nix
    nix-shell --command "export GAMESDIR=$HOME/Games; export FLATPAKDIR=$HOME/.var/app; export MNTDIR=/mnt/crusader/Games; return" -p curl fd gnused innoextract jq ouch powershell sd steam-run unzip wget
```

Run the commands:
``` bash
    ## Arx Fatalis
    mkdir -p "$GAMESDIR"/arx-fatalis
    fd -a -d 1 -e exe . "$MNTDIR/Backups/GOG/arx_fatalis" -x ls -t | head -n1 | xargs innoextract -g -d "$GAMESDIR"/arx-fatalis
    ## ASCII Sector
    mkdir -p "$GAMESDIR/ascii-sector"
    wget -P "$GAMESDIR/ascii-sector" https://s3.amazonaws.com/asciisector/asciisec0.7.2-linux64.tar.gz
    fd -e tar.gz . "$GAMESDIR/ascii-sector" -x ouch d {} -d "$GAMESDIR"/ascii-sector
    mv "$GAMESDIR"/ascii-sector/asciisec "$GAMESDIR"/ascii-sector/asciisec2
    mv "$GAMESDIR"/ascii-sector/asciisec2/* "$GAMESDIR"/ascii-sector
    rm -rf "$GAMESDIR"/ascii-sector/asciisec2
    ## Blake Stone
    mkdir -p "$GAMESDIR"/blake-stone/{aliens-of-gold,planet-strike}
    fd Aliens-of-Gold -a -d 1 -e exe . "$MNTDIR/Backups/Zoom" -x ls -t | head -n1 | xargs innoextract -g -d "$GAMESDIR"/blake-stone/aliens-of-gold
    fd Planet-Strike -a -d 1 -e exe . "$MNTDIR/Backups/Zoom" -x ls -t | head -n1 | xargs innoextract -g -d "$GAMESDIR"/blake-stone/planet-strike
    mv "$GAMESDIR"/blake-stone/aliens-of-gold/app/* "$GAMESDIR"/blake-stone/aliens-of-gold
    mv "$GAMESDIR"/blake-stone/planet-strike/app/* "$GAMESDIR"/blake-stone/planet-strike
    wget -P "$GAMESDIR"/blake-stone/aliens-of-gold https://bibendovsky.github.io/bstone/files/community/aog/bse90.zip \
        https://bibendovsky.github.io/bstone/files/community/aog/guystone.zip \
        https://bibendovsky.github.io/bstone/files/community/aog/lingstone.zip
    wget -P "$GAMESDIR"/blake-stone/planet-strike https://bibendovsky.github.io/bstone/files/community/ps/bse24.zip \
        https://bibendovsky.github.io/bstone/files/community/ps/guystrike.zip \
        https://bibendovsky.github.io/bstone/files/community/ps/lingstrike.zip
    fd -e zip . "$GAMESDIR/blake-stone/aliens-of-gold" -x ouch d {} -d "$GAMESDIR"/blake-stone/aliens-of-gold
    fd -e zip . "$GAMESDIR/blake-stone/planet-strike" -x ouch d {} -d "$GAMESDIR"/blake-stone/planet-strike
    ## Caesar 3
    mkdir -p "$GAMESDIR"/caesar-3
    fd -a -d 1 -e exe . "$MNTDIR/Backups/GOG/caesar_3" -x ls -t | head -n1 | xargs innoextract -g -d "$GAMESDIR"/caesar-3
    mv "$GAMESDIR"/caesar-3/app/* "$GAMESDIR"/caesar-3 && rm -rf "$GAMESDIR"/caesar-3/{app,tmp}
    ## Daikatana
    mkdir -p "$GAMESDIR"/daikatana
    fd -a -d 1 -e exe . "$MNTDIR/Backups/GOG/daikatana" -x ls -t | head -n1 | xargs innoextract -g -d "$GAMESDIR"/daikatana
    wget -P "$GAMESDIR"/daikatana "$(curl https://api.github.com/repos/maraakate/daikatana/releases/latest | jq -r '.assets[] | select(.name | test(".*Linux.*x64.tar.bz2$")).browser_download_url')"
    wget -P "$GAMESDIR"/daikatana/data https://dk.toastednet.org/DK13/pak5.zip \
        https://dk.toastednet.org/Maps/pak9.zip
    fd -a -d 1 -e zip -e bz2 . "$GAMESDIR"/daikatana -x ouch d --yes {} -d "$GAMESDIR"/daikatana
    fd pak5 -a -d 1 -e zip . "$GAMESDIR"/daikatana/data -x unzip {} -d "$GAMESDIR"/daikatana/data
    fd pak9 -a -d 1 -e zip . "$GAMESDIR"/daikatana/data -x unzip {} -d "$GAMESDIR"/daikatana/data
    patch=$(fd --type directory '^Daikatana-Linux' "$GAMESDIR"/daikatana)
    cp -r "$patch"/* "$GAMESDIR"/daikatana
    rm -rf "$GAMESDIR/daikatana/data/pak5.zip" "$GAMESDIR/daikatana/data/pak9.zip" "$GAMESDIR/daikatana/__redist" "$GAMESDIR/daikatana/app" "$GAMESDIR/daikatana/commonappdata" "$GAMESDIR/daikatana/tmp" "$patch"
    ## Dark Forces
    mkdir -p "$FLATPAKDIR"/org.openjkdf2.OpenJKDF2/data/OpenJKDF2/{openjkdf2,openjkmots}
    fd -a -d 1 -e exe . "$MNTDIR/Backups/GOG/star_wars_jedi_knight_dark_forces_ii_copy3" -x ls -t | head -n1 | xargs innoextract -g -d "$FLATPAKDIR"/org.openjkdf2.OpenJKDF2/data/OpenJKDF2/openjkdf2
    fd -a -d 1 -e exe . "$MNTDIR/Backups/GOG/star_wars_republic_commando_copy3" -x ls -t | head -n1 | xargs innoextract -g -d "$FLATPAKDIR"/org.openjkdf2.OpenJKDF2/data/OpenJKDF2/openjkmots
    mv "$FLATPAKDIR"/org.openjkdf2.OpenJKDF2/data/OpenJKDF2/openjkdf2/app/* "$FLATPAKDIR"/org.openjkdf2.OpenJKDF2/data/OpenJKDF2/openjkdf2
    mv "$FLATPAKDIR"/org.openjkdf2.OpenJKDF2/data/OpenJKDF2/openjkmots/app/* "$FLATPAKDIR"/org.openjkdf2.OpenJKDF2/data/OpenJKDF2/openjkmots
    ## Descent
    mkdir -p "$GAMESDIR"/descent/descent-{1,2,3}
    fd -a -d 1 -e exe . "$MNTDIR/Backups/GOG/descent" -x ls -t | head -n1 | xargs innoextract -g -d "$GAMESDIR"/descent/descent-1
    fd -a -d 1 -e exe . "$MNTDIR/Backups/GOG/descent_2" -x ls -t | head -n1 | xargs innoextract -g -d "$GAMESDIR"/descent/descent-2
    fd -a -d 1 -e exe . "$MNTDIR/Backups/GOG/descent_3_expansion" -x ls -t | head -n1 | xargs innoextract -g -d "$GAMESDIR"/descent/descent-3
    mv "$GAMESDIR"/descent/descent-1/app/* "$GAMESDIR"/descent/descent-1 && rm -rf "$GAMESDIR"/descent/descent-1/{app,tmp}
    mv "$GAMESDIR"/descent/descent-2/app/* "$GAMESDIR"/descent/descent-2 && rm -rf "$GAMESDIR"/descent/descent-2/{app,tmp}
    mv "$GAMESDIR"/descent/descent-3/app/* "$GAMESDIR"/descent/descent-3 && rm -rf "$GAMESDIR"/descent/descent-3/{app,tmp}
    ## Diablo
    DATADIR="$FLATPAKDIR/org.diasurgical.DevilutionX/data/diasurgical/devilution"
    mkdir -p "$DATADIR"
    fd -a -d 1 -e exe . "$MNTDIR/Backups/GOG/diablo" -x ls -t | head -n1 | xargs innoextract -d "$DATADIR" -I 'DIABDAT.MPQ' -I 'hellfire.mpq' -I 'hfmonk.mpq' -I 'hfmusic.mpq' -I 'hfvoice.mpq'
    mv "$DATADIR"/hellfire/* $DATADIR
    rm -rf $DATADIR/hellfire
    ## Duke Nukem
    mkdir -p "$GAMESDIR"/duke/{duke-nukem-ii}
    fd Duke-Nukem-II -a -d 1 -e exe . "$MNTDIR/Backups/Zoom" -x ls -t | head -n1 | xargs innoextract -g -d "$GAMESDIR"/duke/duke-nukem-ii -I nukem2.cmp -I nukem2.f1 -I nukem2.f2 -I nukem2.f3 -I nukem2.f4 -I nukem2.f5
    mv "$GAMESDIR"/duke/duke-nukem-ii/app/* "$GAMESDIR"/duke/duke-nukem-ii
    ## Freespace
    mkdir -p "$GAMESDIR"/freespace-2
    fd -a -d 1 -e exe . "$MNTDIR/Backups/GOG/freespace_2" -x ls -t | head -n1 | xargs innoextract -g -d "$GAMESDIR"/freespace-2/FS2
    ## HOMM
    mkdir -p "$XDG_DATA_HOME"/{fheroes2,vcmi}
    fd -a -d 1 -e exe . "$MNTDIR/Backups/GOG/heroes_of_might_and_magic_2_gold_edition" -x ls -t | head -n1 | xargs innoextract -g -d "$XDG_DATA_HOME"/fheroes2
    fd -a -d 1 -e exe . "$MNTDIR/Backups/GOG/heroes_of_might_and_magic_3_complete_edition" -x ls -t | head -n1 | xargs innoextract -g -d "$XDG_DATA_HOME"/vcmi
    ## Jagged Alliance 2
    mkdir -p "$GAMESDIR"/jagged-alliance-2/{ja2,unfinished-business,wildfire}
    fd -a -d 1 -e exe . "$MNTDIR/Backups/GOG/jagged_alliance_2" -x ls -t | head -n1 | xargs innoextract -g -d "$GAMESDIR"/jagged-alliance-2/ja2
    fd -a -d 1 -e exe . "$MNTDIR/Backups/GOG/jagged_alliance_2_unfinished_business" -x ls -t | head -n1 | xargs innoextract -g -d "$GAMESDIR"/jagged-alliance-2/unfinished-business
    fd -a -d 1 -e exe . "$MNTDIR/Backups/GOG/jagged_alliance_2_wildfire" -x ls -t | head -n1 | xargs innoextract -g -d "$GAMESDIR"/jagged-alliance-2/wildfire
    mv "$GAMESDIR"/jagged-alliance-2/ja2/app/* "$GAMESDIR"/jagged-alliance-2/ja2
    mv "$GAMESDIR"/jagged-alliance-2/unfinished-business/app/* "$GAMESDIR"/jagged-alliance-2/unfinished-business
    mv "$GAMESDIR"/jagged-alliance-2/wildfire/app/* "$GAMESDIR"/jagged-alliance-2/wildfire
    ## Jazz Jackrabbit 2
    mkdir -p "$XDG_DATA_HOME"/Jazz² Resurrection/Source
    fd -a -d 1 -e exe . "$MNTDIR/Backups/GOG/jazz_jackrabbit_2_secret_files" -x ls -t | head -n1 | xargs innoextract -g -d "$XDG_DATA_HOME"/Jazz² Resurrection/Source
    fd -a -d 1 -e exe . "$MNTDIR/Backups/GOG/jazz_jackrabbit_2_christmas_chronicles" -x ls -t | head -n1 | xargs innoextract -g -d "$XDG_DATA_HOME"/Jazz² Resurrection/Source
    cd "$XDG_DATA_HOME/Jazz² Resurrection/Source" && rm -rf __redist __support app commonappdata tmp
    ## Jedi Academy
    mkdir -p "$XDG_DATA_HOME"/openjk/base
    fd -a -d 1 -e exe . "$MNTDIR/Backups/GOG/star_wars_jedi_knight_jedi_academy" -x ls -t | head -n1 | xargs innoextract -g -d "$XDG_DATA_HOME"/openjk/base
    ## Jedi Outcast
    mkdir -p "$XDG_DATA_HOME"/openjo/base
    fd -a -d 1 -e exe . "$MNTDIR/Backups/GOG/star_wars_jedi_knight_ii_jedi_outcast" -x ls -t | head -n1 | xargs innoextract -g -d "$XDG_DATA_HOME"/openjo/base
    ## Locomotion
    mkdir -p "$GAMESDIR"/loco
    fd -a -d 1 -e exe . "$MNTDIR/Backups/GOG/chris_sawyers_locomotion" -x ls -t | head -n1 | xargs innoextract -g -d "$GAMESDIR"/loco
    ## Morrowind
    mkdir -p "$GAMESDIR"/{morrowind,openmw}
    fd -a -d 1 -e exe . "$MNTDIR/Backups/GOG/the_elder_scrolls_iii_morrowind_goty_edition_game" -x ls -t | head -n1 | xargs innoextract -g -d "$GAMESDIR"/morrowind
    # https://modding-openmw.com/guides/auto/i-heart-vanilla-directors-cut/linux#selected-mod-list
    wget -P "$GAMESDIR"/openmw https://gitlab.com/api/v4/projects/modding-openmw%2Fmomw-tools-pack/jobs/artifacts/master/raw/momw-tools-pack-linux.tar.gz?job=make
    fd "momw-tools-pack-linux" -t file "$GAMESDIR"/openmw -x ouch d --yes {} -d "$GAMESDIR"/openmw && fd "momw-tools-pack-linux" -t file "$GAMESDIR"/openmw -x rm {}
    ## Oddworld
    mkdir -p "$GAMESDIR"/oddworld/{ao,ae}
    fd "Oddworld-Abe's-Oddysee" -a -d 1 -e exe . "$MNTDIR/Backups/Zoom" -x ls -t | head -n1 | sed 's/^/"/;s/$/"/' | xargs innoextract -d "$GAMESDIR"/oddworld/ao
    mv "$GAMESDIR"/oddworld/ao/app/* "$GAMESDIR"/oddworld/ao && rm -rf "$GAMESDIR"/oddworld/ao/{app,tmp}
    fd "Oddworld-Abe's-Exoddus" -a -d 1 -e exe . "$MNTDIR/Backups/Zoom" -x ls -t | head -n1 | sed 's/^/"/;s/$/"/' | xargs innoextract -d "$GAMESDIR"/oddworld/ae
    mv "$GAMESDIR"/oddworld/ae/app/* "$GAMESDIR"/oddworld/ae && rm -rf "$GAMESDIR"/oddworld/ae/{app,tmp}
    ## Perfect Dark
    mkdir -p "$XDG_DATA_HOME"/perfectdark/data
    wget -P "$XDG_DATA_HOME"/perfectdark/data # TODO: Find new link
    fd -a -d 1 -e zip . "$XDG_DATA_HOME"/perfectdark/data -x ouch d -y {} -d "$XDG_DATA_HOME"/perfectdark/data
    fd -a -d 1 -e z64 . "$XDG_DATA_HOME"/perfectdark/data -x mv {} "$XDG_DATA_HOME"/perfectdark/data/pd.ntsc-final.z64
    fd -a -d 1 -e zip . "$XDG_DATA_HOME"/perfectdark/data -x rm {}
    ## Rollercoaster Tycoon
    mkdir -p "$GAMESDIR"/rollercoaster-tycoon/rct-{1,2}
    fd -a -d 1 -e exe . "$MNTDIR/Backups/GOG/rollercoaster_tycoon_deluxe" -x ls -t | head -n1 | xargs innoextract -g -d "$GAMESDIR"/rollercoaster-tycoon/rct-1
    fd -a -d 1 -e exe . "$MNTDIR/Backups/GOG/rollercoaster_tycoon_2" -x ls -t | head -n1 | xargs innoextract -g -d "$GAMESDIR"/rollercoaster-tycoon/rct-2
    mv "$GAMESDIR"/rollercoaster-tycoon/rct-1/app/* "$GAMESDIR"/rollercoaster-tycoon/rct-1 && rm -rf "$GAMESDIR"/rollercoaster-tycoon/rct-1/{app,tmp}
    ## Super Mario 64
    mkdir -p "$GAMESDIR"/mario-64
    wget -P "$GAMESDIR"/mario-64 # TODO: Find new link
    fd 'Mario' -a -d 1 -e zip "$GAMESDIR"/mario-64 -x ouch d -y {} -d "$GAMESDIR"/mario-64
    fd 'Mario' -a -d 1 -e z64 "$GAMESDIR"/mario-64 -x mv {} "$GAMESDIR"/mario-64/baserom.us.z64
    nix-store --add-fixed sha256 "$GAMESDIR"/mario-64/baserom.us.z64
    fd -a -d 1 -e zip . "$GAMESDIR"/mario-64 -x rm {}
    ## STALKER
    mkdir -p "$XDG_DATA_HOME"/GSC Game World/{"S.T.A.L.K.E.R. - Call of Pripyat","S.T.A.L.K.E.R. - Clear Sky","S.T.A.L.K.E.R. - Shadow of Chernobyl"}
    fd -a -d 1 -e exe . "$MNTDIR/Backups/GOG/stalker_call_of_pripyat_base" -x ls -t | head -n1 | xargs innoextract -g -d "$XDG_DATA_HOME"/GSC Game World/"S.T.A.L.K.E.R. - Call of Pripyat"
    mv "$XDG_DATA_HOME"/GSC Game World/"S.T.A.L.K.E.R. - Call of Pripyat"/game/* "$XDG_DATA_HOME"/GSC Game World/"S.T.A.L.K.E.R. - Call of Pripyat" && rm -rf "$XDG_DATA_HOME/GSC Game World/S.T.A.L.K.E.R. - Call of Pripyat/"{__unpacker,app,DirectX,Foxit,support,tmp}
    ## Serious Sam
    mkdir -p "$FLATPAKDIR"/io.itch.tx00100xt.SeriousSamClassic-VK/data/Serious-Engine/{serioussam,serioussamse}
    fd -a -d 1 -e exe . "$MNTDIR/Backups/GOG/serious_sam_the_first_encounter" -x ls -t | head -n1 | xargs innoextract -g -d "$FLATPAKDIR"/io.itch.tx00100xt.SeriousSamClassic-VK/data/Serious-Engine/serioussam
    fd -a -d 1 -e exe . "$MNTDIR/Backups/GOG/serious_sam_the_second_encounter" -x ls -t | head -n1 | xargs innoextract -g -d "$FLATPAKDIR"/io.itch.tx00100xt.SeriousSamClassic-VK/data/Serious-Engine/serioussamse
    ## Sonic
    mkdir -p "$GAMESDIR"/sonic/sonic-{1,2,3,cd,mania}
    wget -P "$GAMESDIR"/sonic/sonic-1 https://archive.org/download/sonic-rsdk-data/Sonic%201/data.rsdk
    wget -P "$GAMESDIR"/sonic/sonic-2 https://archive.org/download/sonic-rsdk-data/Sonic%202/data.rsdk
    wget -P "$GAMESDIR"/sonic/sonic-3 https://archive.org/download/sonic-and-knuckles-sonic-3_202309/Sonic%20and%20Knuckles%20%26%20Sonic%203.bin
    wget -P "$GAMESDIR"/sonic/sonic-cd https://archive.org/download/sonic-rsdk-data/Sonic%20CD/data.rsdk
    ## Starfox 64
    mkdir -p "$GAMESDIR"/starfox-64
    wget -P "$GAMESDIR"/starfox-64 # TODO: Find new link
    fd 'Star Fox' -a -d 1 -e zip "$GAMESDIR"/starfox-64 -x ouch d -y {} -d "$GAMESDIR"/starfox-64
    fd -a -d 1 -e zip . "$GAMESDIR"/starfox-64 -x rm {}
    ## Theme Hospital
    mkdir -p "$GAMESDIR"/theme-hospital
    fd -a -d 1 -e exe . "$MNTDIR/Backups/GOG/theme_hospital" -x ls -t | head -n1 | xargs innoextract -g -d "$GAMESDIR"/theme-hospital
    ## TTD
    mkdir -p ""$XDG_DATA_HOME"/openttd/baseset"
    fd -a -d 1 -e exe . "$MNTDIR/Backups/GOG/transport_tycoon_deluxe" -x ls -t | head -n1 | xargs innoextract -g -d "$XDG_DATA_HOME"/openttd/baseset/extract
    mv "$XDG_DATA_HOME"/openttd/baseset/extract/CD/* "$XDG_DATA_HOME"/openttd/baseset && rm -rf "$XDG_DATA_HOME"/openttd/extract
    ## Ultima VII
    mkdir -p "$FLATPAKDIR"/info.exult.exult/data/{forgeofvirtue,silverseed}
    fd -a -d 1 -e exe . "$MNTDIR/Backups/GOG/ultima_vii_the_black_gate_the_forge_of_virtue" -x ls -t | head -n1 | xargs innoextract -g -d "$FLATPAKDIR"/info.exult.exult/data/forgeofvirtue
    fd -a -d 1 -e exe . "$MNTDIR/Backups/GOG/ultima_vii_serpent_isle" -x ls -t | head -n1 | xargs innoextract -g -d "$FLATPAKDIR"/info.exult.exult/data/silverseed
    wget -P "$FLATPAKDIR"/info.exult.exult/data https://exult.info/snapshots/fonts_replacement.zip
    fd 'fonts' -a -d 1 -e zip "$FLATPAKDIR"/info.exult.exult/data -x ouch d -y {} -d "$FLATPAKDIR"/info.exult.exult/data/forgeofvirtue/patch
    fd 'fonts' -a -d 1 -e zip "$FLATPAKDIR"/info.exult.exult/data -x ouch d -y {} -d "$FLATPAKDIR"/info.exult.exult/data/silverseed/patch
    fd -a -d 1 -e zip . "$FLATPAKDIR"/info.exult.exult/data -x rm {}
    ## X-COM
    fd -a -d 1 -e exe . "$MNTDIR/Backups/GOG/xcom_ufo_defense" -x ls -t | head -n1 | xargs innoextract -g -d "$XDG_DATA_HOME"/openxcom/UFO
    fd -a -d 1 -e exe . "$MNTDIR/Backups/GOG/xcom_terror_from_the_deep" -x ls -t | head -n1 | xargs innoextract -g -d "$XDG_DATA_HOME"/openxcom/TFTD
    ## Zelda 64
    mkdir -p "$GAMESDIR"/zelda-64
    wget -P "$GAMESDIR"/zelda-64 # TODO: Find new link
    wget -P "$GAMESDIR"/zelda-64 # TODO: Find new link
    fd Ocarina -a -d 1 -e zip "$GAMESDIR"/zelda-64 -x ouch d -y {} -d "$GAMESDIR"/zelda-64/.oot
    fd Majora -a -d 1 -e zip "$GAMESDIR"/zelda-64 -x ouch d -y {} -d "$GAMESDIR"/zelda-64/.mm
    fd Ocarina -a -d 1 -e z64 "$GAMESDIR"/zelda-64/.oot -x mv {} "$GAMESDIR"/zelda-64
    fd Majora -a -d 1 -e z64 "$GAMESDIR"/zelda-64/.mm -x mv {} "$GAMESDIR"/zelda-64/mm.us.rev1.rom.z64
    nix-store --add-fixed sha256 "$GAMESDIR"/zelda-64/mm.us.rev1.rom.z64
    fd -a -d 1 -e zip . "$GAMESDIR"/zelda-64 -x rm {} && rm -rf "$GAMESDIR"/zelda-64/{.mm,.oot}
```
