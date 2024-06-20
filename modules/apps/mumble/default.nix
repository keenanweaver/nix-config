{
  lib,
  config,
  username,
  pkgs,
  ...
}:
let
  cfg = config.mumble;
in
{
  options = {
    mumble = {
      enable = lib.mkEnableOption "Enable mumble in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      home.packages = with pkgs; [ (mumble.override { speechdSupport = true; }) ];
      /*
        xdg = {
             desktopEntries = {
               # For Wayland shortcuts
               "info.mumble.Mumble" = {
                 name = "Mumble";
                 comment = "Low-latency, high quality voice chat software";
                 exec = "env QT_QPA_PLATFORM=xcb mumble %u";
                 terminal = false;
                 icon = "mumble";
                 type = "Application";
                 startupNotify = true;
                 mimeType = [ "x-scheme-handler/mumble" ];
                 categories = [
                   "Network"
                   "Chat"
                   "Qt"
                 ];
               };
             };
           };
      */
    };
  };
}
