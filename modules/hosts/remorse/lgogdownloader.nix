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
          cacheRefreshRetry = ''
            if printf '%s\n' "$output" | grep -qE "^Cache (is too old|doesn.t exist|version doesn.t match current version)\."; then
              echo "game details cache needs a refresh" >&2
              lgogdownloader ${
                lib.escapeShellArgs [
                  "--update-cache"
                  "--include-hidden-products"
                  "--no-color"
                  "--no-unicode"
                  "--no-window-progress"
                  "--verbosity=-1"
                  "--interface=end0"
                ]
              }
              set +o errexit
              output=$(lgogdownloader "''${mainArgs[@]}" 2>&1 | tee >(cat 1>&2))
              status=$?
              set -o errexit
            fi
          '';
          commonDownloadArgs = [
            "--exclude"
            "l,p"
            "--platform=w"
            "--threads=2"
            "--info-threads=2"
            "--limit-rate=15000"
            "--use-cache"
            "--cache-valid=1440"
            "--check-free-space"
            "--include-hidden-products"
            "--ignore-dlc-count"
            "--save-serials"
            "--save-changelogs"
            "--save-game-details-json"
            "--automatic-xml-creation"
            "--no-color"
            "--no-unicode"
            "--no-window-progress"
            "--verbosity=-1"
            "--interface=end0"
            "--blacklist"
            "${gogBlacklistFile}"
            "--directory"
            gogDirectory
          ];
          gog-download = pkgs.writeShellApplication {
            excludeShellChecks = [
              "SC2054"
              "SC2329"
            ];
            name = "gog-download";
            runtimeInputs = with pkgs; [
              curl
              util-linux
              lgogdownloader
            ];
            text = ''
              ${ntfyHelpers}
              ${mkNotifyFinish "GOG download"}
              ${lockHelper}

              mainArgs=(
                ${lib.escapeShellArgs (
                  [
                    "--download"
                    "--updated"
                    "--new"
                    "--clear-update-flags"
                    "--size-only"
                  ]
                  ++ commonDownloadArgs
                )}
              )

              set +o errexit
              output=$(lgogdownloader "''${mainArgs[@]}" 2>&1 | tee >(cat 1>&2))
              status=$?
              set -o errexit

              ${cacheRefreshRetry}

              exit "$status"
            '';
          };
          gog-full-download = pkgs.writeShellApplication {
            excludeShellChecks = [
              "SC2054"
              "SC2329"
            ];
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

              mainArgs=(
                ${lib.escapeShellArgs ([ "--download" ] ++ commonDownloadArgs)}
              )

              set +o errexit
              output=$(lgogdownloader "''${mainArgs[@]}" 2>&1 | tee >(cat 1>&2))
              status=$?
              set -o errexit

              ${cacheRefreshRetry}

              exit "$status"
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
                lib.escapeShellArgs [
                  "--check-orphans"
                  ".*"
                  "--include-hidden-products"
                  "--ignore-dlc-count"
                  "--no-color"
                  "--no-unicode"
                  "--no-window-progress"
                  "--verbosity=-1"
                  "--interface=end0"
                  "--blacklist"
                  "${gogBlacklistFile}"
                  "--directory"
                  gogDirectory
                ]
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
                ${lib.escapeShellArgs [
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
                  "--no-color"
                  "--no-unicode"
                  "--no-window-progress"
                  "--verbosity=-1"
                  "--interface=end0"
                  "--blacklist"
                  "${gogBlacklistFile}"
                  "--directory"
                  gogDirectory
                ]}
              )
              output=$(lgogdownloader "''${redownloadArgs[@]}" 2>&1 | tee >(cat 1>&2))
              success_message="Finished successfully: removed $count orphaned file(s) across $affected_count game director(y/ies), re-downloaded to self-heal"
            '';
          };
          gogBlacklistFile = ../../../assets/hosts/remorse/gog-blacklist.txt;
          gogDirectory = "/mnt/crusader/Games/Backups/GOG";
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
          ntfyTopicUrl = "http://10.20.20.31/gog";
          orphanDirectoryFractionThreshold = 75;
        in
        {
          home.packages = [
            gog-download
            gog-full-download
            gog-remove-orphans
            pkgs.lgogdownloader
          ];
          sops.secrets."ntfy/ntfybot_token" = { };
          systemd.user = {
            services = {
              gog-download = {
                Service = {
                  ExecStart = lib.getExe gog-download;
                  IOSchedulingClass = "idle";
                  Nice = 19;
                  Type = "oneshot";
                };
                Unit.Description = "Scan and download new/updated GOG library files";
              };
              gog-full-download = {
                Service = {
                  ExecStart = lib.getExe gog-full-download;
                  IOSchedulingClass = "idle";
                  Nice = 19;
                  Type = "oneshot";
                };
                Unit.Description = "Full GOG library download, ignoring the updated/new flags";
              };
              gog-remove-orphans = {
                Service = {
                  ExecStart = lib.getExe gog-remove-orphans;
                  IOSchedulingClass = "idle";
                  Nice = 19;
                  Type = "oneshot";
                };
                Unit.Description = "Delete local GOG files no longer present on GOG servers";
              };
            };
            timers = {
              gog-download = {
                Install.WantedBy = [ "timers.target" ];
                Timer = {
                  OnBootSec = "10m";
                  OnCalendar = "*-*-* 10:00:00";
                  Persistent = true;
                  RandomizedDelaySec = "30m";
                };
                Unit.Description = "Daily GOG library scan/download";
              };
              gog-full-download = {
                Install.WantedBy = [ "timers.target" ];
                Timer = {
                  OnCalendar = "monthly";
                  Persistent = true;
                  RandomizedDelaySec = "1h";
                };
                Unit.Description = "Monthly full GOG library download";
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
