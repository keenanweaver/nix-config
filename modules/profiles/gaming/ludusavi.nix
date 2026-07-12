{
  flake.modules.homeManager.gaming-profile = { config, ... }: {
    services.ludusavi = {
      enable = true;
      backupNotification = true;
      settings = {
        backup = {
          format = {
            chosen = "zip";
            zip.compression = "deflate";
          };
        };
        roots = [
          {
            path = "${config.xdg.configHome}/heroic";
            store = "heroic";
          }
          {
            path = "${config.home.homeDirectory}/Games/Heroic";
            store = "heroic";
          }
          {
            path = "${config.xdg.dataHome}/lutris";
            store = "lutris";
          }
          {
            path = "${config.home.homeDirectory}/Games/lutris";
            store = "lutris";
          }
          {
            path = "${config.home.homeDirectory}/Games/Bottles/*";
            store = "otherWine";
          }
          {
            path = "${config.home.homeDirectory}/Games/faugus/*";
            store = "otherWine";
          }
          {
            path = "${config.home.homeDirectory}/Games/Heroic/Prefixes/default/*";
            store = "otherWine";
          }
          {
            path = "${config.home.homeDirectory}/Games/nero/*";
            store = "otherWine";
          }
          {
            path = "${config.home.homeDirectory}/Games/portproton/*";
            store = "otherWine";
          }
          {
            path = "${config.home.homeDirectory}/Games/SteamLibrary";
            store = "steam";
          }
          {
            path = "${config.xdg.dataHome}/Steam";
            store = "steam";
          }
        ];
        theme = "dark";
      };
    };
    systemd.user.timers.ludusavi = {
      Install.WantedBy = [ "timers.target" ];
      Timer = {
        OnBootSec = "2min";
        OnUnitActiveSec = "24h";
      };
    };
  };
}
