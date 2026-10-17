{ self, ... }:
{
  configurations.nixos.nixos-htpc.module = {
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
    boot.loader.timeout = 0;
    system.stateVersion = "26.05";
  };
}
