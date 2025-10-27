{
  lib,
  config,
  username,
  inputs,
  ...
}:
let
  cfg = config.nero-umu;
in
{
  options = {
    nero-umu = {
      enable = lib.mkEnableOption "Enable nero-umu in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} =
      { config, pkgs, ... }:
      {
        home.file = {
          wine-links-proton-cachyos-nero = {
            enable = true;
            source = "${inputs.chaotic.packages.${pkgs.system}.proton-cachyos_x86_64_v4}/bin";
            target = "${config.xdg.dataHome}/Steam/compatibilitytools.d/proton-cachyos-nero";
          };
          wine-links-protonge-nero = {
            enable = true;
            source = "${
              inputs.nur-bandithedoge.legacyPackages.${pkgs.system}.proton.ge
            }/share/steam/compatibilitytools.d/proton-ge";
            target = "${config.xdg.dataHome}/Steam/compatibilitytools.d/GE-Proton10-bin-nero";
          };
        };
        home.packages = with pkgs; [
          nero-umu
        ];
      };
  };
}
