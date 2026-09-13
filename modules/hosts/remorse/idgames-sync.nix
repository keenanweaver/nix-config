{
  configurations.nixos.remorse.module =
    { config, ... }:
    {
      home-manager.users.${config.my.user} =
        { lib, pkgs, ... }:
        let
          idgames-sync = pkgs.writeShellApplication {
            name = "idgames-sync";
            runtimeInputs = [ pkgs.wget ];
            text = "wget ${lib.escapeShellArgs wgetArgs}";
          };
          wgetArgs = [
            "--mirror"
            "--no-parent"
            "--no-host-directories"
            "--cut-dirs=2"
            "--no-verbose"
            "--tries=3"
            "--timeout=30"
            "--limit-rate=1m"
            "--wait=2"
            "--random-wait"
            "--waitretry=10"
            "-e"
            "robots=off"
            "--reject"
            "index.html*"
            "-P"
            "/mnt/crusader/Games/Games/Doom/idgames"
            "https://youfailit.net/pub/idgames/"
          ];
        in
        {
          home.packages = [ idgames-sync ];
          systemd.user = {
            services.idgames-sync = {
              Service = {
                ExecStart = lib.getExe idgames-sync;
                IOSchedulingClass = "idle";
                Nice = 19;
                Type = "oneshot";
              };
              Unit.Description = "Sync the idgames archive from youfailit.net";
            };
            timers.idgames-sync = {
              Install.WantedBy = [ "timers.target" ];
              Timer = {
                OnBootSec = "5m";
                OnCalendar = "monthly";
                Persistent = true;
                RandomizedDelaySec = "1h";
              };
              Unit.Description = "Periodically sync the idgames archive";
            };
          };
        };
    };
}
