{
  self,
  inputs,
  config,
  ...
}:
{
  caches.noctalia = {
    key = "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=";
    url = "https://noctalia.cachix.org";
  };
  flake.modules = {
    homeManager.noctalia =
      { ... }:
      {
        imports = [
          inputs.noctalia.homeModules.default
        ];
        programs.noctalia = {
          enable = true;
          settings = {
            bar.main = {
              center = [ "clock" ];
              end = [
                "tray"
                "network"
                "bluetooth"
                "volume"
                "brightness"
                "nightlight"
                "battery"
                "control-center"
                "session"
              ];
              position = "top";
              start = [
                "launcher"
                "workspaces"
              ];
            };
            calendar.enabled = true;
            control_center.calendar.show_week_numbers = true;
            dock.enabled = false;
            location = self.lib.site.location // {
              auto_locate = false;
            };
            nightlight = {
              enabled = true;
              temperature_day = 6500;
              temperature_night = 3300;
            };
            notification.enable_daemon = true;
            shell.niri_overview_type_to_launch_enabled = true;
            theme = {
              builtin = "Catppuccin";
              mode = "dark";
              source = "builtin";
            };
            wallpaper = {
              default.path = ../../../assets/theming/wallpapers/wallhaven-2kpexy.jpg;
              enabled = true;
              fill_mode = "crop";
            };
            weather = {
              enabled = true;
              unit = "fahrenheit";
            };
          };
        };
      };
    nixos.noctalia =
      { ... }:
      {
        imports = [
          inputs.noctalia.nixosModules.default
        ];
        home-manager.sharedModules = [ self.modules.homeManager.noctalia ];
        nix.settings = self.lib.mkCacheSettings [ config.caches.noctalia ];
        programs.noctalia = {
          enable = true;
          recommendedServices.enable = true;
        };
      };
  };
  flake-file.inputs.noctalia.url = "github:noctalia-dev/noctalia/cachix";
}
