{
  flake.modules.homeManager.profile-desktop =
    { inputs, ... }:
    {
      imports = [
        inputs.omniflake.flakes.pedantix.homeModules.default
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
