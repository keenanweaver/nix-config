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
        home.packages = [
          (inputs.nixdatifier.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
            postInstall = (old.postInstall or "") + ''
              wrapProgram "$plasmoid/contents/tools/sh/release-notes" \
                --run 'export GITHUB_TOKEN="$(cat ${
                  osConfig.sops.secrets."users/${config.home.username}/github_pat".path
                } 2>/dev/null)"'
            '';
          }))
        ];
      };
  };
  flake-file.inputs.nixdatifier = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:Muddyblack/nixdatifier";
  };
}
