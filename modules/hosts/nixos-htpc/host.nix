{ self, ... }:
{
  configurations.nixos.nixos-htpc.module =
    { lib, config, ... }:
    {
      imports = with self.modules.nixos; [
        self.diskoConfigurations.nixos-htpc

        profile-desktop
        profile-kde
        profile-gaming

        amd
        coolercontrol
        secure-boot

        obs
      ];
      boot.loader.timeout = lib.mkForce 0;
      networking.hostName = "nixos-htpc";
      system.stateVersion = "26.05";
      systemd.tmpfiles.rules = [
        "d /mnt/Games 0755 ${config.my.user} users - -"
        "L+ ${config.users.users.${config.my.user}.home}/Games - - - - /mnt/Games"
      ];
    };
}
