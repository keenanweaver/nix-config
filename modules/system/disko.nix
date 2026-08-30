{ inputs, ... }:
{
  imports = [ inputs.omniflake.flakes.disko.flakeModules.default ];
  flake.modules.nixos.profile-base.imports = [
    inputs.omniflake.flakes.disko.nixosModules.disko
  ];
}
