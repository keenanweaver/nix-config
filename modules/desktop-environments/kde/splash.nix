{ inputs, ... }:
{
  flake.modules.nixos.profile-workstation =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.services.desktopManager.plasma6.enable {
        environment.systemPackages = [
          inputs.nixos-mocha-kde-splash.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];
        home-manager.sharedModules = [
          (
            { lib, options, ... }:
            {
              config = lib.optionalAttrs (options.programs ? plasma) {
                programs.plasma.workspace.splashScreen.theme = "nixos-mocha-kde-splash";
              };
            }
          )
        ];
      };
    };
  flake-file.inputs.nixos-mocha-kde-splash = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:michaelwheatland/nixos-mocha-kde-splash";
  };
}
