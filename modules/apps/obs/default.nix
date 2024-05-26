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
      packages = with pkgs; [ obs-cmd ];
      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          input-overlay
          obs-gstreamer
          (obs-pipewire-audio-capture.overrideAttrs (attrs: {
            version = "1.1.4";
            src = fetchFromGitHub {
              owner = "dimtpap";
              repo = "obs-pipewire-audio-capture";
              rev = version;
              hash = "sha256-dL/+Y1uaD+7EY0UNWbxvh1TTLYfgk07qCqLLGvfzWZk=";
            };
          }))
          obs-vkcapture
        ];
      };
      xdg = {
        desktopEntries = {
          com.obsproject.Studio = {
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
