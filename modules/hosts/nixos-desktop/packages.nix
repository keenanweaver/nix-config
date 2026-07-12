{
  configurations.nixos.nixos-desktop.module = { config, ... }: {
    home-manager.users.${config.my.user} =
      {
        lib,
        pkgs,
        inputs,
        ...
      }:
      {
        home.packages = with pkgs; [
          audacious
          audacious-plugins
          caligula
          cyanrip
          filezilla
          local.fooyin
          hacompanion
          handbrake
          haruna
          kdePackages.isoimagewriter
          jellyfin-tui
          kdePackages.kdenlive
          krita
          losslesscut-bin
          mangareader
          metadata-cleaner
          mousai
          neo
          kdePackages.neochat
          okteta
          picard
          projectm-sdl-cpp
          puddletag
          qbz
          qtscrcpy
          rssguard
          signal-desktop
          kdePackages.tokodon
          varia
          winboat
          # Dev #
          codeium
          just
          mdformat
          powershell
          seer
          bash-language-server
          shellcheck
          shellharden
          shfmt
          lua-language-server
          # Misc
          adguardian
          angle-grinder
          bandwhich
          binsider
          csvlens
          flawz
          glances
          glow
          gping
          hexyl
          hyperfine
          impala
          isd
          jiq
          lazyjournal
          magic-wormhole-rs
          #mkvtoolnix-cli
          #patool
          play
          podman-tui
          streamrip
          systemctl-tui
          termscp
          ttysvr
          wikiman
          yq
          ## unix alts ##
          choose # cut
          doggo # dig
          dua # du
          duf # df
          fuc # cp / rm
          pigz # gz
          procs # ps
          sd # sed
          writedisk # dd
          xh # curl
          ## Nix ##
          comma
          deadnix
          manix
          nixd
          nix-inspect
          nix-update
          nixfmt
          nixpkgs-review
          nixos-shell
          nvd
          statix
          optnix
          ### Games ###
          ## Doom
          acc
          inputs.nur-bandithedoge.legacyPackages.${stdenv.hostPlatform.system}.cherry-doom
          chocolate-doom
          crispy-doom
          darkradiant
          doomrunner
          doomseeker
          dsda-doom
          nugget-doom
          inputs.nur-bandithedoge.legacyPackages.${stdenv.hostPlatform.system}.nyan-doom
          odamex
          slade
          uzdoom
          woof-doom
          zandronum
          ## Freespace
          descent3
          dxx-rebirth
          knossosnet
          ## HOMM
          fheroes2
          vcmi
          ## Morrowind
          inputs.openmw-nix.packages.${stdenv.hostPlatform.system}.openmw-validator
          tes3cmd
          openmw
          ## Arma
          arma3-unix-launcher
          # (arma3-unix-launcher.override { buildDayZLauncher = true; })
          ## Duke
          rigel-engine
          ## Wolf
          bstone
          ecwolf
          etlegacy
          ## Other
          abuse
          arx-libertatis # Arx Fatalis
          augustus # Caesar 3
          bolt-launcher # RuneScape
          corsix-th # Theme Hospital
          gamma-launcher
          isle-portable
          jazz2
          katawa-shoujo-re-engineered
          inputs.nix-gaming-edge.packages.${stdenv.hostPlatform.system}.opengoal-launcher
          openjk # Jedi Academy
          openloco
          openomf
          openrct2
          openttd
          opentyrian
          openxcom
          openxray # STALKER
          local.relive # Oddworld
          local.rsdkv3
          inputs.nix-citizen.packages.${stdenv.hostPlatform.system}.rsi-launcher-umu
          sdlpop # Prince of Persia
          sm64ex
          local.sonic3air
          urbanterror
          vvvvvv
          wipeout-rewrite
          yarg

          ## Emulators
          _86box-with-roms
          dosbox-staging
          hypseus-singe
          mednafen
          mednaffe
          mesen
          scummvm
          shadps4
          inputs.nur-bandithedoge.legacyPackages.${stdenv.hostPlatform.system}.sheepshaver-bin
          xenia-canary
          ## Input
          oversteer
          sc-controller
          ## Launchers & utils
          #goverlay
          ## Modding
          hedgemodmanager
          limo
          inputs.just-one-more-repo.packages.${stdenv.hostPlatform.system}.r2modman
          ## Other
          adwsteamgtk
          chiaki-ng
          flips
          gst_all_1.gstreamer
          gst_all_1.gst-libav
          gst_all_1.gst-plugins-base
          gst_all_1.gst-plugins-good
          gst_all_1.gst-plugins-bad
          gst_all_1.gst-plugins-ugly
          gswatcher
          igir
          innoextract
          local.lgogdownloader
          python314Packages.lnkparse3
          parsec-bin
          tochd
          local.xlink-kai
          xvidcore
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
