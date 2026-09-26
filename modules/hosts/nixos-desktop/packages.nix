{ self, inputs, ... }:
let
  inherit (self.lib.site) nas;
in
{
  configurations.nixos.nixos-desktop.module =
    { config, pkgs, ... }:
    {
      home-manager.users.${config.my.user} =
        {
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
              name = "720pclip";
              runtimeInputs = [
                handbrake
              ];
              text = ''
                if [ -z "$1" ]; then
                	echo "Usage: $0 <input_video>"
                	exit 1
                fi

                input="$1"
                output="''${input%.*}_720p60.mp4"

                HandBrakeCLI --preset="Creator 720p60" --input "$input" --output "$output"
              '';
            })
            (writeShellApplication {
              name = "script-exodos-nuked";
              runtimeEnv.EXODOS = "${nas.mountRoot}/Games/eXo/eXoDOS/eXo/eXoDOS";
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
            binsider
            bolt-launcher
            bstone
            caligula
            chiaki-ng
            choose # cut
            corsix-th
            csvlens
            cyanrip
            descent3
            doggo # dig
            dosbox-staging
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
            gping
            gswatcher
            hacompanion
            handbrake
            hedgemodmanager
            hexyl
            hyperfine
            hypseus-singe
            igir
            impala
            innoextract
            inputs.aaru-nix-flake.packages.${system}.default
            inputs.just-one-more-repo.packages.${system}.r2modman
            inputs.nur-packages-bandithedoge.legacyPackages.${system}.sheepshaver-bin
            isd
            isle-portable
            jazz2
            jellyfin-tui
            jiq
            jpsxdec
            katawa-shoujo-re-engineered
            kdePackages.isoimagewriter
            kdePackages.kdenlive
            kdePackages.kigo
            kdePackages.neochat
            kdePackages.tokodon
            knossosnet
            krita
            lazyjournal
            lgogdownloader
            limo
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
            mednafen
            mednaffe
            mesen
            metadata-cleaner
            mkvtoolnix-cli
            mousai
            neo
            nicotine-plus
            nsz
            okteta
            opengoal-launcher
            openjk
            openloco
            openomf
            openrct2
            openttd
            opentyrian
            openxray
            oversteer
            parsec-bin
            patool
            picard
            pigz # gz
            play
            podman-tui
            procs # ps
            ps3-disc-dumper
            puddletag
            python314Packages.lnkparse3
            qtscrcpy
            #redumper
            rigel-engine
            ringracers
            rssguard
            sc-controller
            scummvm
            sd # sed
            sdlpop
            shadps4-qtlauncher
            sm64ex
            srb2
            streamrip
            systemctl-tui
            termscp
            tochd
            ttysvr
            urbanterror
            varia
            vcmi
            wikiman
            winboat
            wipeout-rewrite
            writedisk # dd
            xenia-canary
            xh # curl
            xvidcore
            yarg
            yq
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
      system.extraDependencies = self.lib.pinRoms pkgs [ self.lib.roms.sm64 ];
      xdg.mime.defaultApplications = {
        "audio/*" = "org.fooyin.fooyin.desktop";
        "x-scheme-handler/ror2mm" = "r2modman.desktop";
      };
    };
  flake-file.inputs.aaru-nix-flake = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:Whovian9369/aaru-nix-flake";
  };
}
