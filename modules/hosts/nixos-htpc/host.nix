{ self, ... }:
{
  configurations.nixos.nixos-htpc.module =
    { config, ... }:
    {
      imports = with self.modules.nixos; [
        self.diskoConfigurations.nixos-htpc

        profile-base
        profile-desktop
        profile-gaming

        amd
        secure-boot

        obs
      ];
      home-manager.users.${config.my.user}.imports = with self.modules.homeManager; [
        profile-base
        profile-desktop
        profile-gaming

        amd

        obs
      ];
      networking.hostName = "nixos-htpc";
      nix.settings.build-dir = "/nix/build";
      services.hardware.openrgb.motherboard = "amd";
      system.stateVersion = "26.05";
      systemd.tmpfiles.rules = [
        "d /mnt/Games 0755 ${config.my.user} users - -"
        "L+ /home/${config.my.user}/Games - - - - /mnt/Games"
      ];
    };
}
