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
            version = "0-unstable-2025-07-19";
            src = fetchFromGitHub {
              owner = "SeongGino";
              repo = "Nero-umu";
              rev = "c4301703275b30ecf526116253ef85802ef2548d";
              hash = "sha256-vSynh1Xsbv8OKkOZwMzI0+V6IlIyGJWQDPW4FCMNhbk=";
            };
          })
        ];
      };
  };
}
