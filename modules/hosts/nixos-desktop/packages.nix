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
        let
          inherit (pkgs.stdenv.hostPlatform) system;
        in
        {
          home.packages = with pkgs; [
            (writeShellApplication {
              name = "script-exodos-nuked";
              runtimeEnv.EXODOS = "/mnt/crusader/Games/eXo/eXoDOS/eXo/eXoDOS";
              runtimeInputs = [
                fd
                sd
              ];
              text = ''
                fd -t file "run.bat" $EXODOS -x sd 'CONFIG -set "mididevice=fluidsynth"' 'CONFIG -set "mididevice=soundcanvas"' {}
              '';
            })
            _86box-with-roms
            abuse
            acc
            adguardian
            adwsteamgtk
            angle-grinder
            arma3-unix-launcher
            arx-libertatis
            audacious
            audacious-plugins
            augustus
            bandwhich
            bash-language-server
            binsider
            bolt-launcher
            bstone
            caligula
            chiaki-ng
            chocolate-doom
            choose # cut
            codeium
            comma
            corsix-th
            crispy-doom
            csvlens
            #cyanrip
            darkradiant
            deadnix
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
            fheroes2
            filezilla
            flawz
            flips
            fooyin
            fuc # cp / rm
            #gamma-launcher
            glances
            glow
            gnugo
            goverlay
            gping
            gswatcher
            hacompanion
            handbrake
            haruna
            hedgemodmanager
            hexyl
            hyperfine
            hypseus-singe
            igir
            impala
            innoextract
            inputs.omniflake.flakes.aaru-nix-flake.packages.${system}.default
            inputs.omniflake.flakes.just-one-more-repo.packages.${system}.r2modman
            #inputs.omniflake.flakes.nix-game-preservation.packages.${system}.dic-git-full
            #inputs.omniflake.flakes.nix-game-preservation.packages.${system}.ndecrypt-git
            #inputs.omniflake.flakes.nix-game-preservation.packages.${system}.sabretools-git
            #inputs.omniflake.flakes.nix-game-preservation.packages.${system}.unshieldsharp-git
            inputs.omniflake.flakes.nur-packages-bandithedoge.legacyPackages.${system}.cherry-doom
            inputs.omniflake.flakes.nur-packages-bandithedoge.legacyPackages.${system}.nyan-doom
            inputs.omniflake.flakes.nur-packages-bandithedoge.legacyPackages.${system}.sheepshaver-bin
            isd
            isle-portable
            jazz2
            jellyfin-tui
            jiq
            jpsxdec
            just
            katawa-shoujo-re-engineered
            kdePackages.isoimagewriter
            kdePackages.kdenlive
            kdePackages.kigo
            kdePackages.neochat
            kdePackages.tokodon
            knossosnet
            krita
            lazyjournal
            limo
            local.lgogdownloader
            local.openxcom-extended
            local.relive
            local.rsdkv3
            local.sonic3air
            local.xlink-kai
            losslesscut-bin
            lua-language-server
            magic-wormhole-rs
            mame.tools
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
            nicotine-plus
            nix-inspect
            nix-update
            nixd
            nixfmt
            nixos-shell
            nixpkgs-review
            nsz
            nugget-doom
            nvd
            odamex
            okteta
            opengoal-launcher
            openjk
            openloco
            openomf
            openrct2
            openttd
            opentyrian
            openxray
            optnix
            oversteer
            parsec-bin
            patool
            #picard
            pigz # gz
            play
            podman-tui
            powershell
            procs # ps
            projectm-sdl-cpp
            ps3-disc-dumper
            #puddletag
            python314Packages.lnkparse3
            qbz
            qtscrcpy
            redumper
            rigel-engine
            ringracers
            rssguard
            sc-controller
            scummvm
            sd # sed
            sdlpop
            seer
            shadps4-qtlauncher
            shellcheck
            shellharden
            shfmt
            signal-desktop
            slade
            sm64ex
            srb2
            statix
            streamrip
            systemctl-tui
            termscp
            tochd
            ttysvr
            urbanterror
            uzdoom
            varia
            vcmi
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
