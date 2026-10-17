{ self, ... }:
{
  configurations.nixos.nixos-desktop.module =
    { config, ... }:
    {
      imports = with self.modules.nixos; [
        self.diskoConfigurations.nixos-desktop

        profile-workstation
        profile-kde
        profile-gaming

        amd
        coolercontrol
        secure-boot
        zerotier

        flatpak-games
        moonshine
        obs
        obs-flatpak
        retroarch
        stream-controller
        yeetmouse

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
          ...
        }:
        {
          xdg.desktopEntries = import ./_desktop-entries.nix {
            inherit
              config
              lib
              pkgs
              ;
          };
        };
      system.stateVersion = "26.05";
      systemd.tmpfiles.rules = [
        "d /mnt/Games2 0755 ${config.my.user} users - -"
      ];
    };
}
