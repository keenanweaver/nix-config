{ self, ... }:
{
  configurations.nixos.nixos-laptop.module = { config, ... }: {
    imports = with self.modules.nixos; [
      self.diskoConfigurations.nixos-laptop

      base-profile
      desktop-profile
      office-profile

      secure-boot
      virtualization
      wireless

      #niri
      #noctalia

      solaar
      vscodium
    ];
    boot.loader.limine.style.interface.resolution = "1920x1080";
    hardware.facter.reportPath = ./facter.json;
    home-manager.users.${config.my.user} = {
      imports = with self.modules.homeManager; [
        base-profile
        desktop-profile

        #niri
        #noctalia

        fluxer
        freetube
        halloy
        mumble
        solaar
        vesktop
        vscodium
      ];
    };
    networking.hostName = "nixos-laptop";
    system.stateVersion = "26.05";
  };
}
