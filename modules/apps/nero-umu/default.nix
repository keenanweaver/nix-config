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
            source = config.lib.file.mkOutOfStoreSymlink "${
              inputs.chaotic.packages.${pkgs.system}.proton-cachyos
            }/bin";
            target = "${config.xdg.dataHome}/Steam/compatibilitytools.d/proton-cachyos-nero";
          };
          wine-links-protonge-nero = {
            enable = true;
            source = config.lib.file.mkOutOfStoreSymlink "${pkgs.proton-ge-bin.steamcompattool}";
            target = "${config.xdg.dataHome}/Steam/compatibilitytools.d/GE-Proton10-bin-nero";
          };
        };
        home.packages = with pkgs; [
          (nero-umu.overrideAttrs {
            version = "1.1.3-unstable-2025-08-20";
            src = fetchFromGitHub {
              owner = "SeongGino";
              repo = "Nero-umu";
              rev = "34e6b8b91eb1cd8b19ffdf63ec3e01cf37e5eb14";
              hash = "sha256-NqU0I/Vn1elu1yoReIES26Yx9dCotw+1C9vPaBNf4x0=";
            };
          })
        ];
      };
  };
}
