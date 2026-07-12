{
  flake.modules = {
    homeManager = {
      obs =
        {
          pkgs,
          osConfig,
          self,
          ...
        }:
        {
          imports = with self.modules.homeManager; [ obs-shared ];
          config = {
            home.packages = with pkgs; [ obs-cmd ];
            programs.obs-studio = {
              enable = true;
              plugins = with pkgs.obs-studio-plugins; [
                input-overlay
                obs-gstreamer
                obs-pipewire-audio-capture
                obs-vkcapture
              ];
            };
            xdg.desktopEntries.obs = {
              categories = [
                "AudioVideo"
                "Recorder"
              ];
              comment = "Free and Open Source Streaming/Recording Software";
              exec = "GDK_BACKEND=x11 QT_QPA_PLATFORM=xcb obs --disable-shutdown-check";
              icon = "com.obsproject.Studio";
              name = "OBS Studio [${osConfig.my.user}]";
              startupNotify = true;
              terminal = false;
              type = "Application";
            };
          };
        };
      obs-flatpak =
        {
          osConfig,
          self,
          ...
        }:
        {
          imports = with self.modules.homeManager; [ obs-shared ];
          services.flatpak = {
            overrides."com.obsproject.Studio".Context.sockets = [ "!wayland" ];
            packages = [
              "com.obsproject.Studio"
              "com.obsproject.Studio.Plugin.InputOverlay"
              "com.obsproject.Studio.Plugin.OBSVkCapture"
            ];
          };
          xdg.desktopEntries."com.obsproject.Studio" = {
            categories = [
              "AudioVideo"
              "Recorder"
            ];
            comment = "Flatpak - Free and Open Source Streaming/Recording Software";
            exec = "flatpak run --branch=stable --arch=x86_64 --command=obs com.obsproject.Studio --disable-shutdown-check";
            icon = "com.obsproject.Studio";
            name = "OBS Studio [${osConfig.my.user}]";
            startupNotify = true;
            terminal = false;
            type = "Application";
          };
        };
      obs-shared = {
        config = {
          home.sessionVariables = {
            OBS_VKCAPTURE_QUIET = "1";
          };
          services.flatpak.packages = [
            "org.freedesktop.Platform.VulkanLayer.OBSVkCapture/x86_64/23.08"
            "org.freedesktop.Platform.VulkanLayer.OBSVkCapture/x86_64/24.08"
            "org.freedesktop.Platform.VulkanLayer.OBSVkCapture/x86_64/25.08"
          ];
        };
      };
    };
    nixos.obs = { config, ... }: {
      boot = {
        extraModprobeConfig = ''
          options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
        '';
        extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
        kernelModules = [ "v4l2loopback" ];
      };
    };
  };
}
