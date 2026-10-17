{ self, ... }:
{
  configurations.nixos.nixos-laptop.module = {
    imports = with self.modules.nixos; [
      self.diskoConfigurations.nixos-laptop

      profile-workstation
      profile-kde
      profile-niri

      amd
      secure-boot
    ];
    boot.loader.limine.style.interface.resolution = "1920x1080";
    system.stateVersion = "26.05";
  };
}
