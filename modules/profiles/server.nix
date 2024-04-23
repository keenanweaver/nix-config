{ inputs, home-manager, lib, config, pkgs, username, ... }: with lib;
let
  cfg = config.desktop;
in
{
  imports = [
    ./base.nix
  ];

  options = {
    desktop = {
      enable = mkEnableOption "Enable desktop in NixOS";
    };
  };
  config = mkIf cfg.enable {
    # Custom modules
    base.enable = true;
    catppuccinTheming.enable = true;
    hyprland.enable = false;
    kde.enable = false;

    # Server tweaks
    distrobox.enable = lib.mkForce false;
    mullvad.enable = lib.mkForce false;
    printing.enable = lib.mkForce false;
    virtualization.enable = lib.mkForce false;

    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
      home.packages = with pkgs; [ ];
    };
  };
}
