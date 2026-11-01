{ inputs, ... }:
{
  imports = [ inputs.disko.flakeModules.default ];
  flake.modules.nixos.profile-base =
    { lib, config, ... }:
    let
      reportPath = ../../assets/hosts/${config.networking.hostName}/facter.json;
    in
    {
      imports = [
        inputs.disko.nixosModules.disko
      ];
      hardware.facter.reportPath = lib.mkIf (builtins.pathExists reportPath) reportPath;
    };
  flake-file.inputs.disko = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:nix-community/disko";
  };
}
