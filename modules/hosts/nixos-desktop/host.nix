{ self, ... }:
{
  configurations.nixos.nixos-desktop.module =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      imports = with self.modules.nixos; [
        self.diskoConfigurations.nixos-desktop

        base-profile
        desktop-profile
        gaming-profile
        office-profile

        amd
        secure-boot
        virtualization

        moonshine
        obs
        solaar
        stream-controller
        #sunshine
        vscodium
      ];

      boot = {
        binfmt = {
          emulatedSystems = [
            "aarch64-linux"
          ];
        };
      };

      fileSystems = {
        "/mnt/Games" = {
          device = "/dev/disk/by-id/nvme-Samsung_SSD_990_EVO_Plus_4TB_S7U8NJ0Y515050E-part1";
          fsType = "btrfs";

          options = [
            "compress=zstd:3"
            "nofail"
          ];
        };

        "/mnt/Games2" = {
          device = "/dev/disk/by-id/ata-Samsung_SSD_870_EVO_2TB_S620NJ0R902825F-part1";
          fsType = "btrfs";

          options = [
            "compress=zstd:3"
            "nofail"
          ];
        };

        "/mnt/windows" = {
          device = "/dev/disk/by-id/nvme-WDS250G2X0C-00L350_182012421668_1-part3";
          fsType = "ntfs";

          options = [
            "uid=1000"
            "gid=1000"
            "rw"
            "user"
            "exec"
            "umask=000"
          ];
        };
      };

      hardware = {
        firmware = [
          (pkgs.runCommand "edid-gbt-aorus-fo27q3" { } ''
            mkdir -p $out/lib/firmware/edid
            cp ${./gbt-aorus-fo27q3.bin} $out/lib/firmware/edid/gbt-aorus-fo27q3.bin
          '')
        ];
      };

      hardware.facter.reportPath = ./facter.json;

      home-manager.users.${config.my.user} =
        {
          lib,
          config,
          pkgs,
          osConfig,
          ...
        }:
        {
          imports = with self.modules.homeManager; [
            base-profile
            desktop-profile
            gaming-profile

            amd
            flatpak-games
            llm

            fluxer
            freetube
            halloy
            mumble
            obs
            obs-flatpak
            retroarch
            solaar
            sunshine
            vesktop
            vscodium
          ];

          home = {
            packages = with pkgs; [
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
            ];

            sessionVariables = {
              WAYLANDDRV_PRIMARY_MONITOR = "DP-1"; # https://reddit.com/r/linux_gaming/comments/1louxm2/fix_for_wine_wayland_using_wrong_monitor/
              WINE_CPU_TOPOLOGY = "15:1,2,3,4,5,6,7,16,17,18,19,20,21,22,23"; # 7950X3D
            };
          };

          xdg.desktopEntries = import ./_desktop-entries.nix {
            inherit
              lib
              config
              pkgs
              osConfig
              ;
          };
        };

      networking.hostName = "nixos-desktop";
      powerManagement.cpuFreqGovernor = "ondemand";
      system.stateVersion = "26.05";

      systemd = {
        services."network-addresses-wlp11s0".wantedBy = lib.mkForce [ ];

        tmpfiles.rules = [
          "d /mnt/Games 0755 ${config.my.user} users - -"
          "d /mnt/Games2 0755 ${config.my.user} users - -"
          "L+ /home/${config.my.user}/Games - - - - /mnt/Games"
          "L+ /home/${config.my.user}/Games2 - - - - /mnt/Games2"
        ];
      };
    };
}
