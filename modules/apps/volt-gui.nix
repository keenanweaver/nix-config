{ inputs, ... }:
{
  flake.modules.homeManager.profile-gaming = { pkgs, ... }: {
    home.packages = [ inputs.volt-gui-nix.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  };
  flake-file.inputs.volt-gui-nix = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:keygenesis/volt-gui-nix";
  };
}
