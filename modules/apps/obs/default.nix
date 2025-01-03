{
  lib,
  config,
  username,
  pkgs,
  ...
}:
let
  cfg = config.obs;
in
{
  options = {
    obs = {
      enable = lib.mkEnableOption "Enable obs in home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      home = {
        packages = with pkgs; [
          obs-cmd
        ];
        sessionVariables = {
          OBS_VKCAPTURE_QUIET = "1";
        };
      };
      programs.obs-studio = {
        enable = true;
        plugins = with pkgs; [
          obs-studio-plugins.input-overlay
          obs-studio-plugins.looking-glass-obs
          obs-studio-plugins.obs-gstreamer
          obs-studio-plugins.obs-pipewire-audio-capture
          obs-studio-plugins.obs-vaapi
          obs-studio-plugins.obs-vkcapture
        ];
      };
      xdg = {
        desktopEntries = {
          "obs" = {
            name = "OBS Studio";
            comment = "Free and Open Source Streaming/Recording Software";
            exec = "env QT_QPA_PLATFORM=xcb GDK_BACKEND=x11 obs --disable-shutdown-check"; # Run with XWayland compatibility for docks
            terminal = false;
            icon = "com.obsproject.Studio";
            type = "Application";
            startupNotify = true;
            categories = [
              "AudioVideo"
              "Recorder"
            ];
          };
        };
      };
    };
  };
}
