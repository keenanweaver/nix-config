{ self, ... }:
{
  configurations.nixos.nixos-desktop.module =
    { lib, config, ... }:
    {
      imports = with self.modules.nixos; [
        self.diskoConfigurations.nixos-desktop

        profile-workstation
        profile-kde
        profile-gaming

        amd
        coolercontrol
        secure-boot

        flatpak-games
        moonshine
        obs
        obs-flatpak
        retroarch
        stream-controller

        doom
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
          home.sessionVariables.WINE_CPU_TOPOLOGY = "15:1,2,3,4,5,6,7,16,17,18,19,20,21,22,23"; # 7950X3D
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
      system.stateVersion = "26.05";
      systemd = {
        services.network-addresses-wlp11s0.wantedBy = lib.mkForce [ ];
        tmpfiles.rules = [
          "d /mnt/Games 0755 ${config.my.user} users - -"
          "d /mnt/Games2 0755 ${config.my.user} users - -"
          "L+ ${config.users.users.${config.my.user}.home}/Games - - - - /mnt/Games"
        ];
      };
    };
}
