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
            enable = false;
            source = config.lib.file.mkOutOfStoreSymlink "${
              inputs.nix-proton-cachyos.packages.${pkgs.system}.proton-cachyos
            }/share/steam/compatibilitytools.d/proton-cachyos";
            target = "${config.xdg.dataHome}/Nero-UMU/compatibilitytools.d/proton-cachyos";
          };
          wine-links-protonge-nero = {
            enable = false;
            source = config.lib.file.mkOutOfStoreSymlink "${
              inputs.chaotic.packages.${pkgs.system}.proton-ge-custom
            }/bin";
            target = "${config.xdg.dataHome}/Nero-UMU/compatibilitytools.d/proton-ge-custom";
          };
        };
        home.packages = with pkgs; [ nero-umu ];
      };
  };
}
