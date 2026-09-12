{ self, ... }:
{
  configurations.nixos.nixos-desktop.module =
    { lib, config, ... }:
    {
      imports = with self.modules.nixos; [
        self.diskoConfigurations.nixos-desktop

        profile-base
        profile-desktop
        profile-gaming
        profile-office

        amd
        secure-boot
        virtualization

        moonshine
        obs
        solaar
        stream-controller
        vscodium

        star-citizen
      ];
      boot.binfmt.emulatedSystems = [
        "aarch64-linux"
      ];
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
            profile-base
            profile-desktop
            profile-gaming

            amd
            flatpak-games
            llm

            #fluxer
            freetube
            halloy
            mumble
            obs
            obs-flatpak
            retroarch
            stream-controller
            vesktop
            vscodium

            doom
          ];
          home.sessionVariables = {
            WAYLANDDRV_PRIMARY_MONITOR = "DP-1"; # https://reddit.com/r/linux_gaming/comments/1louxm2/fix_for_wine_wayland_using_wrong_monitor/
            WINE_CPU_TOPOLOGY = "15:1,2,3,4,5,6,7,16,17,18,19,20,21,22,23"; # 7950X3D
          };
          xdg.desktopEntries = import ./_desktop-entries.nix {
            inherit
              config
              lib
              osConfig
              pkgs
              ;
          };
        };
      networking.hostName = "nixos-desktop";
      services.hardware.openrgb.motherboard = "amd";
      system.stateVersion = "26.05";
      systemd = {
        services."network-addresses-wlp11s0".wantedBy = lib.mkForce [ ];
        tmpfiles.rules = [
          "d /mnt/Games 0755 ${config.my.user} users - -"
          "d /mnt/Games2 0755 ${config.my.user} users - -"
          "L+ /home/${config.my.user}/Games - - - - /mnt/Games"
        ];
      };
    };
}
