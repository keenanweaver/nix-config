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
    catppuccinTheming.enable = lib.mkForce false;
    packages.enable = lib.mkForce false;

    # Server tweaks
    boxxy.enable = lib.mkForce false;
    direnv.enable = lib.mkForce false;
    distrobox.enable = lib.mkForce false;
    keyd.enable = lib.mkForce false;
    mullvad.enable = lib.mkForce false;
    office.enable = lib.mkForce false;
    pipewire.enable = lib.mkForce false;
    tailscale.enable = lib.mkForce false;

    users.users.${username} = {
      autoSubUidGidRange = true;
      linger = true;
    };

    home-manager.users.${username} = { };
  };
}
