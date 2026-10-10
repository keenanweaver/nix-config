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
          timelineColor = palette.overlay1.hex;
          useSystemTextColor = false;
        };
        name = "org.muddyblack.nixosGenerationExplorer";
      };
    modules.homeManager.nixdatifier =
      { pkgs, ... }:
      {
        home.packages = [ inputs.nixdatifier.packages.${pkgs.stdenv.hostPlatform.system}.default ];
      };
  };
  flake-file.inputs.nixdatifier = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:Muddyblack/nixdatifier";
  };
}
