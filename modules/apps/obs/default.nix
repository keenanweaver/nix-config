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
      enableFlatpak = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      enableNative = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      silenceOutput = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      home = {
        packages = lib.mkIf cfg.enableNative [
          pkgs.obs-cmd
        ];
        sessionVariables = lib.mkIf cfg.silenceOutput {
          OBS_VKCAPTURE_QUIET = "1";
        };
      };
      programs.obs-studio = {
        enable = cfg.enableNative;
        plugins = with pkgs.obs-studio-plugins; [
          input-overlay
          obs-gstreamer
          obs-pipewire-audio-capture
          obs-vaapi
          obs-vkcapture
        ];
      };
      services.flatpak = {
        overrides = lib.mkIf cfg.enableFlatpak {
          "com.obsproject.Studio" = {
            Context = {
              sockets = [
                "!wayland" # Disable Wayland so it shows Twitch panels / mouse cursor capture in games
              ];
            };
          };
        };
        packages = lib.mkIf cfg.enableFlatpak [
          "com.obsproject.Studio"
          "com.obsproject.Studio.Plugin.InputOverlay"
          "com.obsproject.Studio.Plugin.OBSVkCapture"
          "org.freedesktop.Platform.VulkanLayer.OBSVkCapture/x86_64/24.08"
        ];
      };
      xdg = {
        desktopEntries = {
          "com.obsproject.Studio" = lib.mkIf cfg.enableFlatpak {
            name = "OBS Studio";
            comment = "Flatpak - Free and Open Source Streaming/Recording Software";
            exec = "flatpak run --branch=stable --arch=x86_64 --command=obs com.obsproject.Studio --disable-shutdown-check";
            terminal = false;
            icon = "com.obsproject.Studio";
            type = "Application";
            startupNotify = true;
            categories = [
              "AudioVideo"
              "Recorder"
            ];
          };
          "obs" = lib.mkIf cfg.enableNative {
            name = "OBS Studio";
            comment = "Free and Open Source Streaming/Recording Software";
            exec = "GDK_BACKEND=x11 QT_QPA_PLATFORM=xcb obs --disable-shutdown-check";
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
