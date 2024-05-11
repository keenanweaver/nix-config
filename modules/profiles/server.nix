{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.server;
in
{
  imports = [ ./base.nix ];

  options = {
    server = {
      enable = lib.mkEnableOption "Enable server in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {
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

    home-manager.users.${username} = { };
  };
}
