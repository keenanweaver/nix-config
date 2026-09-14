{
  configurations.nixos.remorse.module =
    { config, ... }:
    {
      home-manager.users.${config.my.user} =
        {
          lib,
          config,
          pkgs,
          ...
        }:
        let
          idgames-sync = pkgs.writeShellApplication {
            excludeShellChecks = [ "SC2329" ];
            name = "idgames-sync";
            runtimeInputs = [
              pkgs.curl
              pkgs.wget
            ];
            text = ''
              ${ntfyHelpers}
              notify_finish() {
                local exit_code=$1
                if [ "$exit_code" -eq 0 ]; then
                  ntfy_notify "idgames sync" "Finished successfully" "white_check_mark"
                else
                  ntfy_notify "idgames sync" "Failed (exit $exit_code)" "x" "high"
                fi
              }
              trap 'notify_finish $?' EXIT
              ntfy_notify "idgames sync" "Started" "arrow_forward"

              wget ${lib.escapeShellArgs wgetArgs}
            '';
          };
          ntfyHelpers = ''
            ntfy_notify() {
              local title="$1" message="$2" tags="$3" priority="''${4:-default}"
              curl -fsS \
                --header "Authorization: Bearer $(cat ${lib.escapeShellArg ntfyTokenFile})" \
                --header "Title: $title" \
                --header "Tags: $tags" \
                --header "Priority: $priority" \
                --data "$message" \
                "http://10.20.20.31/idgames" >/dev/null || true
            }
          '';
          ntfyTokenFile = config.sops.secrets."ntfy/ntfybot_token".path;
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
          sops.secrets."ntfy/ntfybot_token" = { };
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
