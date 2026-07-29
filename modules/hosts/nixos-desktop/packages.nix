{
  configurations.nixos.nixos-desktop.module =
    { config, ... }:
    {
      home-manager.users.${config.my.user} =
        {
          inputs,
          lib,
          pkgs,
          ...
        }:
        {
          home.packages = with pkgs; [
            ## One-and-dones
            /*
              inputs.aaru.packages.${stdenv.hostPlatform.system}.default
                 inputs.nix-game-preservation.packages.${stdenv.hostPlatform.system}.dic-git-full
                 glxinfo
                 jpsxdec
                 mame.tools
                 mmv
                 inputs.nix-game-preservation.packages.${stdenv.hostPlatform.system}.ndecrypt-git
                 nsz
                 inputs.nix-game-preservation.packages.${stdenv.hostPlatform.system}.sabretools-git
                 inputs.nix-game-preservation.packages.${stdenv.hostPlatform.system}.unshieldsharp-git
                 openspeedrun
                 ps3-disc-dumper
                 inputs.nix-game-preservation.packages.${stdenv.hostPlatform.system}.redumper-git
                 renderdoc
                 vgmplay-libvgm
                 vgmstream
                 vgmtools
                 vgmtrans
                 vulkan-tools
            */
            (writeShellApplication {
              name = "script-exodos-nuked";

              runtimeEnv = {
                EXODOS = "/mnt/crusader/Games/eXo/eXoDOS/eXo/eXoDOS";
              };

              runtimeInputs = [
                fd
                sd
              ];

              text = ''
                fd -t file "run.bat" $EXODOS -x sd 'CONFIG -set "mididevice=fluidsynth"' 'CONFIG -set "mididevice=soundcanvas"' {}
              '';
            })
            (writeShellApplication {
              name = "script-momw-update";

              runtimeEnv = {
                MODLIST = "i-heart-vanilla-directors-cut";
              };

              runtimeInputs = [
                inputs.openmw-nix.packages.${stdenv.hostPlatform.system}.momw-configurator
                inputs.openmw-nix.packages.${stdenv.hostPlatform.system}.openmw-validator
                inputs.openmw-nix.packages.${stdenv.hostPlatform.system}.umo
                tes3cmd
              ];

              text = ''
                umo sync "$MODLIST"
                umo install "$MODLIST"
                momw-configurator config "$MODLIST" --run-navmeshtool --run-validator
                umo vacuum
              '';
            })
            ## Emulators
            _86box-with-roms
            ## Other
            abuse
            ### Games ###
            ## Doom
            acc
            # Misc
            adguardian
            ## Other
            adwsteamgtk
            angle-grinder
            ## Arma
            arma3-unix-launcher
            arx-libertatis # Arx Fatalis
            audacious
            audacious-plugins
            augustus # Caesar 3
            bandwhich
            bash-language-server
            binsider
            bolt-launcher # RuneScape
            ## Wolf
            bstone
            caligula
            chiaki-ng
            chocolate-doom
            ## unix alts ##
            choose # cut
            # Dev #
            codeium
            ## Nix ##
            comma
            corsix-th # Theme Hospital
            crispy-doom
            csvlens
            cyanrip
            darkradiant
            deadnix
            ## Freespace
            descent3
            doggo # dig
            doomrunner
            doomseeker
            dosbox-staging
            dsda-doom
            dua # du
            duf # df
            dxx-rebirth
            ecwolf
            etlegacy
            ## HOMM
            fheroes2
            filezilla
            flawz
            flips
            fuc # cp / rm
            #glances
            glow
            ## Launchers & utils
            goverlay
            gping
            gst_all_1.gst-libav
            gst_all_1.gst-plugins-bad
            gst_all_1.gst-plugins-base
            gst_all_1.gst-plugins-good
            gst_all_1.gst-plugins-ugly
            gst_all_1.gstreamer
            gswatcher
            hacompanion
            handbrake
            haruna
            ## Modding
            hedgemodmanager
            hexyl
            hyperfine
            hypseus-singe
            igir
            impala
            innoextract
            inputs.just-one-more-repo.packages.${stdenv.hostPlatform.system}.r2modman
            inputs.nix-citizen.packages.${stdenv.hostPlatform.system}.rsi-launcher-umu
            inputs.nix-gaming-edge.packages.${stdenv.hostPlatform.system}.opengoal-launcher
            inputs.nur-bandithedoge.legacyPackages.${stdenv.hostPlatform.system}.cherry-doom
            inputs.nur-bandithedoge.legacyPackages.${stdenv.hostPlatform.system}.nyan-doom
            inputs.nur-bandithedoge.legacyPackages.${stdenv.hostPlatform.system}.sheepshaver-bin
            ## Morrowind
            inputs.openmw-nix.packages.${stdenv.hostPlatform.system}.openmw-validator
            isd
            #gamma-launcher
            isle-portable
            jazz2
            jellyfin-tui
            jiq
            just
            katawa-shoujo-re-engineered
            kdePackages.isoimagewriter
            kdePackages.kdenlive
            kdePackages.neochat
            kdePackages.tokodon
            knossosnet
            krita
            lazyjournal
            limo
            local.fooyin
            local.lgogdownloader
            local.relive # Oddworld
            local.rsdkv3
            local.sonic3air
            local.xlink-kai
            losslesscut-bin
            lua-language-server
            magic-wormhole-rs
            mangareader
            manix
            mdformat
            mednafen
            mednaffe
            mesen
            metadata-cleaner
            mkvtoolnix-cli
            mousai
            neo
            nix-inspect
            nix-update
            nixd
            nixfmt
            nixos-shell
            nixpkgs-review
            nugget-doom
            nvd
            odamex
            okteta
            openjk # Jedi Academy
            openloco
            openmw
            openomf
            openrct2
            openttd
            opentyrian
            openxcom
            openxray # STALKER
            optnix
            ## Input
            oversteer
            parsec-bin
            patool
            picard
            pigz # gz
            play
            podman-tui
            powershell
            procs # ps
            projectm-sdl-cpp
            puddletag
            python314Packages.lnkparse3
            qbz
            qtscrcpy
            # (arma3-unix-launcher.override { buildDayZLauncher = true; })
            ## Duke
            rigel-engine
            rssguard
            sc-controller
            scummvm
            sd # sed
            sdlpop # Prince of Persia
            seer
            shadps4-qtlauncher
            shellcheck
            shellharden
            shfmt
            signal-desktop
            slade
            sm64ex
            statix
            streamrip
            systemctl-tui
            termscp
            tes3cmd
            tochd
            ttysvr
            urbanterror
            uzdoom
            varia
            vcmi
            vvvvvv
            wikiman
            winboat
            wipeout-rewrite
            woof-doom
            writedisk # dd
            xenia-canary
            xh # curl
            xvidcore
            yarg
            yq
            zandronum
          ];

          programs = {
            plasma.hotkeys.commands.gsr-save-replay = {
              command = lib.getExe (
                pkgs.writeShellApplication {
                  name = "gsr-save-replay";
                  runtimeInputs = [ pkgs.killall ];

                  text = ''
                    killall -SIGUSR1 gpu-screen-recorder
                  '';
                }
              );

              comment = "Save GPU Screen Recorder replay";
              key = "Meta+Alt+]";
              name = "Save GSR Replay";
            };

            prismlauncher.enable = true;
          };
        };

      programs = {
        k3b.enable = true;
        perfect-dark-git.enable = true;
      };
    };
}
