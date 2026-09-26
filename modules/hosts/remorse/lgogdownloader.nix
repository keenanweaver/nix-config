{ self, ... }:
{
  configurations.nixos.remorse.module =
    { config, ... }:
    {
      home-manager.users.${config.my.user} =
        {
          lib,
          config,
          pkgs,
          osConfig,
          ...
        }:
        let
          cachedFetchArgs = fetchArgs ++ [
            "--use-cache"
            "--cache-valid=1440"
          ];
          fetchArgs = [
            "--exclude"
            "l,p"
            "--platform=w"
            "--threads=2"
            "--info-threads=2"
            "--limit-rate=15000"
            "--check-free-space"
            "--include-hidden-products"
            "--ignore-dlc-count"
            "--save-serials"
            "--save-changelogs"
            "--save-game-details-json"
            "--automatic-xml-creation"
          ]
          ++ outputArgs
          ++ targetArgs;
          gog-full-download = pkgs.writeShellApplication {
            excludeShellChecks = [ "SC2329" ];
            name = "gog-full-download";
            runtimeInputs = with pkgs; [
              curl
              util-linux
              lgogdownloader
            ];
            text = ''
              ${ntfyHelpers}
              ${mkNotifyFinish "GOG full download"}
              ${lockHelper}

              echo "refreshing game details cache"
              output=$(lgogdownloader ${
                lib.escapeShellArgs (
                  [
                    "--update-cache"
                    "--include-hidden-products"
                  ]
                  ++ outputArgs
                )
              } </dev/null 2>&1 | tee >(cat 1>&2))

              output=$(lgogdownloader ${
                lib.escapeShellArgs (
                  [
                    "--download"
                    "--clear-update-flags"
                  ]
                  ++ cachedFetchArgs
                )
              } </dev/null 2>&1 | tee >(cat 1>&2))
            '';
          };
          gog-new-games = pkgs.writeShellApplication {
            excludeShellChecks = [ "SC2329" ];
            name = "gog-new-games";
            runtimeInputs = with pkgs; [
              curl
              util-linux
              lgogdownloader
            ];
            text = ''
              ${ntfyHelpers}
              ${mkNotifyFinish "GOG new games"}
              ${lockHelper}

              output=$(lgogdownloader ${
                lib.escapeShellArgs (
                  [
                    "--download"
                    "--new"
                  ]
                  ++ fetchArgs
                )
              } </dev/null 2>&1 | tee >(cat 1>&2))
            '';
          };
          gog-remove-orphans = pkgs.writeShellApplication {
            excludeShellChecks = [
              "SC2054"
              "SC2329"
            ];
            name = "gog-remove-orphans";
            runtimeInputs = with pkgs; [
              coreutils
              curl
              findutils
              util-linux
              lgogdownloader
            ];
            text = ''
              ${ntfyHelpers}
              ${mkNotifyFinish "GOG orphan cleanup"}
              ${lockHelper}

              output=$(lgogdownloader ${
                lib.escapeShellArgs (
                  [
                    "--check-orphans"
                    ".*"
                    "--include-hidden-products"
                    "--ignore-dlc-count"
                  ]
                  ++ outputArgs
                  ++ targetArgs
                )
              })

              mapfile -t orphans < <(printf '%s\n' "$output" | sed '/^$/d')
              if [ "''${#orphans[@]}" -eq 1 ] && [ "''${orphans[0]}" = "No orphaned files" ]; then
                orphans=()
              fi
              count=''${#orphans[@]}

              if [ "$count" -eq 0 ]; then
                echo "no orphaned files found"
                success_message="Finished successfully: no orphaned files found"
                exit 0
              fi

              total_dirs=$(find ${lib.escapeShellArg gogDirectory} -mindepth 1 -maxdepth 1 -type d | wc -l)
              if [ "$total_dirs" -eq 0 ]; then
                echo "refusing to delete: ${gogDirectory} has no game directories at all" >&2
                exit 1
              fi

              declare -A affected_dirs
              for path in "''${orphans[@]}"; do
                rel=$(realpath -m --relative-to=${lib.escapeShellArg gogDirectory} -- "$path")
                affected_dirs["''${rel%%/*}"]=1
              done
              affected_count=''${#affected_dirs[@]}
              affected_percent=$((affected_count * 100 / total_dirs))

              if [ "$affected_percent" -ge ${toString orphanDirectoryFractionThreshold} ]; then
                {
                  echo "refusing to delete: $count orphaned files span $affected_count of $total_dirs game directories (''${affected_percent}%), at or above the ${toString orphanDirectoryFractionThreshold}% threshold"
                  echo "this usually means the scan itself is wrong"
                  echo "orphaned files reported by this scan:"
                  printf '%s\n' "''${orphans[@]}"
                } >&2
                exit 1
              fi

              printf 'deleting %s\n' "''${orphans[@]}"
              rm -f -- "''${orphans[@]}"

              gameFilter=""
              for dir in "''${!affected_dirs[@]}"; do
                escaped=$(printf '%s' "$dir" | sed -E 's/[][\.^$*+?(){}|]/\\&/g')
                gameFilter="''${gameFilter:+$gameFilter|}$escaped"
              done
              echo "re-downloading affected games to self-heal any false-positive deletions: ''${!affected_dirs[*]}"

              redownloadArgs=(
                --download --game "^($gameFilter)\$"
                ${lib.escapeShellArgs fetchArgs}
              )
              output=$(lgogdownloader "''${redownloadArgs[@]}" 2>&1 | tee >(cat 1>&2))
              success_message="Finished successfully: removed $count orphaned file(s) across $affected_count game director(y/ies), re-downloaded to self-heal"
            '';
          };
          gogBlacklistFile = ../../../assets/hosts/remorse/gog-blacklist.txt;
          gogDirectory = self.lib.site.nas.paths.gogBackups;
          lockHelper = ''
            lockfile="''${XDG_RUNTIME_DIR:-/tmp}/gog-lgogdownloader.lock"
            exec {lock_fd}>"$lockfile"
            flock --wait 3600 "$lock_fd"
          '';
          mkNotifyFinish = jobName: ''
            success_message="Finished successfully"
            notify_finish() {
              local exit_code=$1
              if [ "$exit_code" -eq 0 ]; then
                ntfy_notify "${jobName}" "$success_message" "white_check_mark"
              else
                ntfy_notify "${jobName}" "Failed (exit $exit_code).''${output:+
            $(tail -n 15 <<<"$output")}" "x" "high"
              fi
            }
            trap 'notify_finish $?' EXIT
            ntfy_notify "${jobName}" "Started" "arrow_forward"
          '';
          mkService = script: description: {
            Service = {
              ExecStart = lib.getExe script;
              IOSchedulingClass = "idle";
              Nice = 19;
              Type = "oneshot";
            };
            Unit.Description = description;
          };
          ntfyHelpers = self.lib.mkNtfyNotify {
            click = true;
            token = "$(cat ${lib.escapeShellArg config.sops.secrets."ntfy/ntfybot_token".path})";
            topicUrl = "http://${self.lib.site.network.hosts.regret}/gog";
          };
          orphanDirectoryFractionThreshold = 75;
          outputArgs = [
            "--no-color"
            "--no-unicode"
            "--no-window-progress"
            "--verbosity=-1"
            "--interface=${osConfig.host.lanInterface}"
          ];
          targetArgs = [
            "--blacklist"
            "${gogBlacklistFile}"
            "--directory"
            gogDirectory
          ];
        in
        {
          home.packages = [
            gog-full-download
            gog-new-games
            gog-remove-orphans
            pkgs.lgogdownloader
          ];
          sops.secrets."ntfy/ntfybot_token" = { };
          systemd.user = {
            services = {
              gog-full-download = mkService gog-full-download "Refresh GOG library details and download new or updated files";
              gog-new-games = mkService gog-new-games "Download newly owned GOG games";
              gog-remove-orphans = mkService gog-remove-orphans "Delete local GOG files no longer present on GOG servers";
            };
            timers = {
              gog-full-download = {
                Install.WantedBy = [ "timers.target" ];
                Timer = {
                  OnCalendar = "monthly";
                  Persistent = true;
                  RandomizedDelaySec = "1h";
                };
                Unit.Description = "Monthly GOG library update download";
              };
              gog-new-games = {
                Install.WantedBy = [ "timers.target" ];
                Timer = {
                  OnBootSec = "5m";
                  OnCalendar = "daily";
                  RandomizedDelaySec = "5m";
                };
                Unit.Description = "Daily download of new GOG games";
              };
              gog-remove-orphans = {
                Install.WantedBy = [ "timers.target" ];
                Timer = {
                  OnCalendar = "weekly";
                  Persistent = true;
                  RandomizedDelaySec = "1h";
                };
                Unit.Description = "Weekly GOG orphaned-file cleanup";
              };
            };
          };
        };
    };
}
