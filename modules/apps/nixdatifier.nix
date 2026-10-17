{ inputs, lib, ... }:
{
  flake = {
    lib.plasmaWidgets.nixdatifier =
      hmConfig:
      let
        inherit (hmConfig.catppuccin) accent flavor sources;
        palette = (lib.importJSON "${sources.palette}/palette.json").${flavor}.colors;
      in
      {
        config.General = {
          accentColor = palette.${accent}.hex;
          bgColor = "#f5${lib.removePrefix "#" palette.base.hex}";
          customTextColor = palette.text.hex;
          flakePath = hmConfig.programs.nh.flake;
          iconStyle = "accent";
          showNotifications = false;
          timelineColor = palette.overlay1.hex;
          useSystemTextColor = false;
        }
        // lib.optionalAttrs (hmConfig.programs.nixdatifier.githubTokenFile != null) {
          inherit (hmConfig.programs.nixdatifier) githubTokenFile;
        };
        name = "org.muddyblack.nixosGenerationExplorer";
      };
    modules.homeManager.nixdatifier =
      {
        config,
        pkgs,
        osConfig,
        ...
      }:
      {
        imports = [ inputs.nixdatifier.homeManagerModules.default ];
        programs.nixdatifier = {
          enable = true;
          package = inputs.nixdatifier.packages.${pkgs.stdenv.hostPlatform.system}.default;
          autostart = false;
          githubTokenFile = osConfig.sops.secrets."users/${config.home.username}/github_pat".path;
        };
      };
  };
  flake-file.inputs.nixdatifier = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:Muddyblack/nixdatifier";
  };
}
