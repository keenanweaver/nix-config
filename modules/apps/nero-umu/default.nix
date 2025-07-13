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
              inputs.nix-proton-cachyos.packages.${pkgs.system}.proton-cachyos
            }/share/steam/compatibilitytools.d/proton-cachyos";
            target = "${config.xdg.dataHome}/Steam/compatibilitytools.d/proton-cachyos-nero";
          };
          wine-links-protonge-nero = {
            enable = true;
            source = config.lib.file.mkOutOfStoreSymlink "${
              inputs.chaotic.packages.${pkgs.system}.proton-ge-custom
            }/bin";
            target = "${config.xdg.dataHome}/Steam/compatibilitytools.d/GE-Proton10-custom-nero";
          };
        };
        home.packages = with pkgs; [
          (nero-umu.overrideAttrs {
            version = "0-unstable-2025-07-12";
            src = fetchFromGitHub {
              owner = "SeongGino";
              repo = "Nero-umu";
              rev = "23e044e0d775a39a781a21f314f80119ea016dde";
              hash = "sha256-EndsQk3jxdjCczxNt5NPEZUyIAGMudH36ZpKVagmiII=";
            };
          })
        ];
      };
  };
}
