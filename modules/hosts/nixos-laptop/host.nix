{ self, ... }:
{
  configurations.nixos.nixos-laptop.module =
    { config, ... }:
    {
      imports = with self.modules.nixos; [
        self.diskoConfigurations.nixos-laptop

        profile-base
        profile-desktop
        profile-office

        secure-boot
        virtualization
        wireless

        solaar
        vscodium
      ];
      boot.loader.limine.style.interface.resolution = "1920x1080";
      home-manager.users.${config.my.user}.imports = with self.modules.homeManager; [
        profile-base
        profile-desktop

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
