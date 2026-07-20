{ self, ... }:
{
  configurations.nixos.nixos-htpc.module = { config, ... }: {
    imports = with self.modules.nixos; [
      self.diskoConfigurations.nixos-htpc

      base-profile
      desktop-profile
      gaming-profile

      amd
      secure-boot

      obs
    ];

    fileSystems."/mnt/Games" = {
      options = [
        "compress=zstd:3"
        "nofail"
      ];
      device = "/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_2TB_S73WNJ0TB09290J-part1";
      fsType = "btrfs";
    };

    hardware.facter.reportPath = ./facter.json;

    home-manager.users.${config.my.user} = {
      imports = with self.modules.homeManager; [
        base-profile
        desktop-profile
        gaming-profile

        amd

        obs
      ];
    };

    networking.hostName = "nixos-htpc";

    system.stateVersion = "26.05";

    systemd.tmpfiles.rules = [
      "d /mnt/Games 0755 ${config.my.user} users - -"
      "L+ /home/${config.my.user}/Games - - - - /mnt/Games"
    ];
  };
}
