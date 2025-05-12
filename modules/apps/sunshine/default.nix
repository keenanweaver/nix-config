{
  lib,
  config,
  username,
  pkgs,
  ...
}:
{
  options = {
    sunshine = {
      enable = lib.mkEnableOption "Enable Sunshine in NixOS";
    };
  };
  config = lib.mkIf config.sunshine.enable {
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
      applications = {
        env = {
          PATH = "$(PATH):/run/current-system/sw/bin:/etc/profiles/per-user/${username}/bin:$(HOME)/.local/bin";
        };
        apps = [
          {
            name = "Desktop";
            image-path = "desktop.png";
          }
          {
            name = "MoonDeckStream";
            cmd = "${pkgs.moondeck-buddy}/bin/MoonDeckStream";
            exclude-global-prep-cmd = "false";
            elevated = "false";
          }
          {
            name = "Steam Big Picture";
            image-path = "steam.png";
            detached = [ "steam steam://open/bigpicture" ];
            auto-detach = "true";
            wait-all = "true";
            exit-timeout = "5";
          }
        ];
      };
      settings = {
        output_name = 1;
      };
    };
    home-manager.users.${username} = { };
  };
}
