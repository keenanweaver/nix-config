{ self, ... }:
{
  configurations.nixos.remorse.module =
    { config, ... }:
    {
      imports = with self.modules.nixos; [
        profile-base
        profile-pi
      ];
      home-manager.users.${config.my.user}.imports = with self.modules.homeManager; [
        profile-base
        profile-pi
      ];
      networking.hostName = "remorse";
      system.stateVersion = "26.05";
    };
}
