{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.nero-umu;
in
{
  options = {
    nero-umu = {
      enable = lib.mkEnableOption "Enable nero-umu in home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} =
      { config, pkgs, ... }:
      {
        home.file = {
          proton-links-proton-cachyos-nero = {
            enable = true;
            source = "${pkgs.proton-cachyos-x86_64_v4}/share/steam/compatibilitytools.d/proton-cachyos-x86_64_v4";
            target = "${config.xdg.dataHome}/Steam/compatibilitytools.d/GE-Proton10-proton-cachyos-nero-nix";
          };
          proton-links-proton-em-nero = {
            enable = true;
            source = pkgs.proton-em.steamcompattool;
            target = "${config.xdg.dataHome}/Steam/compatibilitytools.d/GE-Proton10-proton-em-nero-nix";
          };
          proton-links-proton-ge-nero = {
            enable = true;
            source = pkgs.proton-ge.steamcompattool;
            target = "${config.xdg.dataHome}/Steam/compatibilitytools.d/GE-Proton10-nero-nix";
          };
        };
        home.packages = with pkgs; [
          nero-umu
        ];
      };
  };
}
