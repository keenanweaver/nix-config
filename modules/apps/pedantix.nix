{ inputs, ... }:
{
  flake.modules.homeManager.profile-desktop =
    { ... }:
    {
      imports = [
        inputs.pedantix.homeModules.default
      ];
      programs.pedantix = {
        enable = true;
        settings = {
          lets.sort = true;
          preset = "nixos-module";
        };
      };
    };
}
