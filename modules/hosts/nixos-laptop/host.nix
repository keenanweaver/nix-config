{ self, ... }:
{
  configurations.nixos.nixos-laptop.module =
    { lib, config, ... }:
    {
      imports = with self.modules.nixos; [
        self.diskoConfigurations.nixos-laptop

        profile-workstation
        profile-kde
        profile-niri

        amd
        secure-boot
      ];
      boot.loader.limine.style.interface.resolution = "1920x1080";
      home-manager.users.${config.my.user} =
        { pkgs, ... }:
        {
          home.packages = with pkgs; [
            kdePackages.neochat
            rssguard
          ];
        };
      nix-mineral.settings.kernel = {
        iommu-passthrough = lib.mkForce true; # if false, boot doesn't work
        strict-iommu = false; # if true, boot doesn't work
      };
      system.stateVersion = "26.05";
    };
}
