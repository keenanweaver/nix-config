{ self, ... }:
{
  configurations.nixos.nixos-laptop.module =
    { config, ... }:
    {
      imports = with self.modules.nixos; [
        self.diskoConfigurations.nixos-laptop

        base-profile
        desktop-profile
        office-profile

        secure-boot
        virtualization
        wireless

        solaar
        vscodium
      ];
      boot.loader.limine.style.interface.resolution = "1920x1080";
      hardware.facter.reportPath = ./facter.json;
      home-manager.users.${config.my.user}.imports = with self.modules.homeManager; [
        base-profile
        desktop-profile

        llm

        fluxer
        freetube
        halloy
        mumble
        vesktop
        vscodium
      ];
      networking.hostName = "nixos-laptop";
      nix.settings.build-dir = "/nix/build";
      system.stateVersion = "26.05";
    };
}
