{
  configurations.nixos.remorse.module =
    { config, ... }:
    {
      home-manager.users.${config.my.user} =
        { lib, pkgs, ... }:
        let
          gog-download = pkgs.writeShellApplication {
            excludeShellChecks = [ "SC2054" ];
            name = "gog-download";
            runtimeInputs = with pkgs; [
              util-linux
              local.lgogdownloader
            ];
            text = ''
              lockfile="''${XDG_RUNTIME_DIR:-/tmp}/gog-lgogdownloader.lock"
              exec {lock_fd}>"$lockfile"
              flock --wait 3600 "$lock_fd"

              mainArgs=(
                ${lib.escapeShellArgs [
                  "--download"
                  "--updated"
                  "--new"
                  "--clear-update-flags"
                  "--exclude"
                  "l,p"
                  "--platform=w"
                  "--threads=2"
                  "--info-threads=2"
                  "--limit-rate=15000"
                  "--size-only"
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
                ]}
              )

              set +o errexit
              output=$(lgogdownloader "''${mainArgs[@]}" 2>&1 | tee /dev/stderr)
              status=$?
              set -o errexit

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
                output=$(lgogdownloader "''${mainArgs[@]}" 2>&1 | tee /dev/stderr)
                status=$?
                set -o errexit
              fi

              exit "$status"
            '';
          };
          gog-full-download = pkgs.writeShellApplication {
            excludeShellChecks = [ "SC2054" ];
            name = "gog-full-download";
            runtimeInputs = with pkgs; [
              util-linux
              local.lgogdownloader
            ];
            text = ''
              lockfile="''${XDG_RUNTIME_DIR:-/tmp}/gog-lgogdownloader.lock"
              exec {lock_fd}>"$lockfile"
              flock --wait 3600 "$lock_fd"

              mainArgs=(
                ${lib.escapeShellArgs [
                  "--download"
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
                ]}
              )

              set +o errexit
              output=$(lgogdownloader "''${mainArgs[@]}" 2>&1 | tee /dev/stderr)
              status=$?
              set -o errexit

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
                output=$(lgogdownloader "''${mainArgs[@]}" 2>&1 | tee /dev/stderr)
                status=$?
                set -o errexit
              fi

              exit "$status"
            '';
          };
          gog-remove-orphans = pkgs.writeShellApplication {
            excludeShellChecks = [ "SC2054" ];
            name = "gog-remove-orphans";
            runtimeInputs = with pkgs; [
              coreutils
              findutils
              util-linux
              local.lgogdownloader
            ];
            text = ''
              lockfile="''${XDG_RUNTIME_DIR:-/tmp}/gog-lgogdownloader.lock"
              exec {lock_fd}>"$lockfile"
              flock --wait 3600 "$lock_fd"

              orphan_output=$(lgogdownloader ${
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

              mapfile -t orphans < <(printf '%s\n' "$orphan_output" | sed '/^$/d')
              if [ "''${#orphans[@]}" -eq 1 ] && [ "''${orphans[0]}" = "No orphaned files" ]; then
                orphans=()
              fi
              count=''${#orphans[@]}

              if [ "$count" -eq 0 ]; then
                echo "no orphaned files found"
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
              lgogdownloader "''${redownloadArgs[@]}"
            '';
          };
          gogBlacklistFile = ../../../assets/hosts/remorse/gog-blacklist.txt;
          gogDirectory = "/mnt/crusader/Games/Backups/GOG";
          orphanDirectoryFractionThreshold = 75;
        in
        {
          home.packages = [
            gog-download
            gog-full-download
            gog-remove-orphans
            pkgs.local.lgogdownloader
          ];
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
                  OnCalendar = "daily";
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
