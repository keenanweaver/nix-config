{ self, ... }:
{
  configurations.nixos.nixos-laptop.module = {
    imports = with self.modules.nixos; [
      self.diskoConfigurations.nixos-laptop

      profile-workstation
      profile-kde
      profile-niri

      secure-boot
    ];
    boot.loader.limine.style.interface.resolution = "1920x1080";
    networking.hostName = "nixos-laptop";
    system.stateVersion = "26.05";
  };
}
