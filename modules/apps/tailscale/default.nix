{
  lib,
  config,
  username,
  pkgs,
  ...
}:
let
  cfg = config.tailscale;
in
{
  options = {
    tailscale = {
      enable = lib.mkEnableOption "Enable tailscale in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    services = {
      tailscale = {
        enable = true;
        openFirewall = true;
        extraSetFlags = [
          "--advertise-exit-node"
        ];
        useRoutingFeatures = "both";
      };
    };

    home-manager.users.${username} = {
      home.packages = with pkgs; [ ktailctl ];
      xdg.autostart.entries = with pkgs; [
        "${ktailctl}/share/applications/org.fkoehler.KTailctl.desktop"
      ];
    };
  };
}
