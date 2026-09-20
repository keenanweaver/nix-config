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
            runtimeInputs = with pkgs; [
              curl
              wget
            ];
            text = ''
              ${ntfyHelpers}
              logfile=$(mktemp)
              final_status=""

              notify_finish() {
                local exit_code=$1
                local status="''${final_status:-$exit_code}"
                local summary
                summary=$(grep -E '^(Downloaded|Total wall clock time):' "$logfile" | tr '\n' ' ')
                case "$status" in
                  ok)
                    ntfy_notify "idgames sync" "Finished successfully. $summary" "white_check_mark"
                    ;;
                  partial)
                    ntfy_notify "idgames sync" "Finished, but some files errored (wget exit 8). $summary
              $(tail -n 15 "$logfile")" "warning"
                    ;;
                  *)
                    ntfy_notify "idgames sync" "Failed (exit $status).
              $(tail -n 15 "$logfile")" "x" "high"
                    ;;
                esac
                rm -f "$logfile"
              }
              trap 'notify_finish $?' EXIT
              ntfy_notify "idgames sync" "Started" "arrow_forward"

              if wget ${lib.escapeShellArgs wgetArgs} 2>&1 | tee "$logfile"; then
                wget_rc=0
              else
                wget_rc=''${PIPESTATUS[0]}
              fi

              if [ "$wget_rc" -eq 0 ]; then
                final_status=ok
              elif [ "$wget_rc" -eq 8 ]; then
                final_status=partial
              else
                exit "$wget_rc"
              fi
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
                --header "Click: ${ntfyTopicUrl}" \
                --data "$message" \
                "${ntfyTopicUrl}" >/dev/null || true
            }
          '';
          ntfyTokenFile = config.sops.secrets."ntfy/ntfybot_token".path;
          ntfyTopicUrl = "http://10.20.20.31/idgames";
          wgetArgs = [
            "--mirror"
            "--no-parent"
            "--no-host-directories"
            "--cut-dirs=2"
            "--no-verbose"
            "--tries=3"
            "--timeout=30"
            "--limit-rate=8m"
            "--wait=1"
            "--random-wait"
            "-e"
            "robots=off"
            "--reject"
            "index.html*"
            "--reject-regex"
            "\\?C="
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
