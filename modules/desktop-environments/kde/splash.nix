{ inputs, ... }:
{
  flake.modules = {
    homeManager.plasma-manager.programs.plasma.workspace.splashScreen.theme = "nixos-mocha-kde-splash";
    nixos.profile-kde =
      { pkgs, ... }:
      {
        environment.systemPackages = [
          inputs.nixos-mocha-kde-splash.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];
      };
  };
  flake-file.inputs.nixos-mocha-kde-splash = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:michaelwheatland/nixos-mocha-kde-splash";
  };
}
