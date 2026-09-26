{ self, ... }:
{
  flake.modules.homeManager.profile-gaming =
    {
      lib,
      config,
      pkgs,
      osConfig,
      ...
    }:
    let
      cfg = config.services.ludusavi;
    in
    {
      services.ludusavi = {
        enable = true;
        settings = {
          backup.format = {
            chosen = "zip";
            zip.compression = "deflate";
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
              path = "${config.home.homeDirectory}/Games/vermouth/*";
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
      systemd.user = {
        services.ludusavi.Service.ExecStartPost = [
          (lib.escapeShellArgs [
            (lib.getExe config.programs.rclone.package)
            "copy"
            cfg.settings.backup.path
            "${self.lib.site.nas.mountRoot}/Games/Saves/ludusavi/${osConfig.networking.hostName}"
          ])
          "${lib.getExe pkgs.libnotify} 'Ludusavi' 'Backup completed' -i com.mtkennerly.ludusavi -a 'Ludusavi'"
        ];
        timers.ludusavi = {
          Install.WantedBy = [ "timers.target" ];
          Timer = {
            OnBootSec = "2min";
            OnUnitActiveSec = "24h";
          };
        };
      };
    };
}
