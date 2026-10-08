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
          cacheArgs = [
            "--use-cache"
            "--cache-valid=${toString cacheMaxAgeMinutes}"
          ];
          cacheFile = "${config.xdg.cacheHome}/lgogdownloader/gamedetails.json";
          cacheMaxAgeMinutes = 10080;
          gog-full-download = mkScript "gog-full-download" ''
            echo "refreshing game details cache"
            lgogdownloader --update-cache </dev/null 2>&1 | tee "$workdir/cache.log"
            fail_on_cache_error <"$workdir/cache.log"

            run_download --download ${lib.escapeShellArgs cacheArgs}

            rm -f -- ${lib.escapeShellArg newGamesSkipFile}
          '';
          gog-new-games = mkScript "gog-new-games" ''
            skip_file=${lib.escapeShellArg newGamesSkipFile}
            mkdir -p "$(dirname "$skip_file")"
            touch "$skip_file"

            owned=$(lgogdownloader --list=games --include=bi </dev/null | sed -E '/^\+> /d; s/ \[[0-9]+\]$//; /^$/d' | sort -u)
            if [ -z "$owned" ]; then
              echo "GOG returned an empty game list" >&2
              exit 1
            fi

            local_dirs=$(find ${lib.escapeShellArg gogDirectory} -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort -u)
            if [ -z "$local_dirs" ]; then
              echo "refusing to run: ${gogDirectory} has no game directories (NAS not mounted?)" >&2
              exit 1
            fi

            mapfile -t missing < <(
              comm -23 <(printf '%s\n' "$owned") <(printf '%s\n' "$local_dirs") |
                comm -23 - <(sort -u "$skip_file")
            )
            if [ "''${#missing[@]}" -eq 0 ]; then
              echo "no new games"
              exit 0
            fi
            if [ "''${#missing[@]}" -gt ${toString newGamesMaxBatch} ]; then
              {
                echo "refusing to download ''${#missing[@]} games at once (limit ${toString newGamesMaxBatch}); run gog-full-download instead"
                printf '%s\n' "''${missing[@]}"
              } >&2
              exit 1
            fi
            echo "downloading ''${#missing[@]} new game(s): ''${missing[*]}"

            run_download --download --game "$(game_filter "''${missing[@]}")"

            for game in "''${missing[@]}"; do
              if [ ! -d ${lib.escapeShellArg gogDirectory}/"$game" ]; then
                echo "$game produced no files; skipping it until the next full download"
                echo "$game" >>"$skip_file"
              fi
            done
          '';
          gog-remove-orphans = mkScript "gog-remove-orphans" ''
            if [ -z "$(find ${lib.escapeShellArg cacheFile} -mmin -${toString cacheMaxAgeMinutes} 2>/dev/null)" ]; then
              echo "refreshing game details cache"
              lgogdownloader --update-cache </dev/null 2>&1 | tee "$workdir/cache.log"
              fail_on_cache_error <"$workdir/cache.log"
            fi

            scan_errors="$workdir/scan-errors"
            output=$(lgogdownloader --check-orphans '.*' ${lib.escapeShellArgs cacheArgs} </dev/null 2>"$scan_errors")
            cat "$scan_errors" >&2
            fail_on_cache_error <"$scan_errors"

            mapfile -t orphans < <(printf '%s\n' "$output" | sed '/^$/d')
            if [ "''${#orphans[@]}" -eq 1 ] && [ "''${orphans[0]}" = "No orphaned files" ]; then
              orphans=()
            fi
            count=''${#orphans[@]}

            if [ "$count" -eq 0 ]; then
              echo "no orphaned files found"
              exit 0
            fi

            if [ "$count" -gt ${toString orphanMaxFiles} ]; then
              {
                echo "refusing to delete: $count orphaned files is more than the limit of ${toString orphanMaxFiles}"
                echo "this usually means the scan itself is wrong"
                echo "orphaned files reported by this scan:"
                printf '%s\n' "''${orphans[@]}"
              } >&2
              exit 1
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

            echo "re-downloading affected games to self-heal any false-positive deletions: ''${!affected_dirs[*]}"
            run_download --download --game "$(game_filter "''${!affected_dirs[@]}")" ${lib.escapeShellArgs cacheArgs}
            echo "removed $count orphaned file(s) across $affected_count game director(y/ies)"
          '';
          gogBlacklistFile = ../../../assets/hosts/remorse/gog-blacklist.txt;
          gogDirectory = self.lib.site.nas.paths.gogBackups;
          gogIgnorelistFile = pkgs.writeText "gog-ignorelist.txt" ''
            R /serials(_[^/]*)?\.txt$
            R /changelog_[^/]*\.html$
            R /game-details\.json$
            R /product_[^/]*\.json$
          '';
          mkCommonHelpers = jobName: ''
            ${ntfyHelpers}
            workdir=$(mktemp -d)
            report="$workdir/report.log"

            finish() {
              local exit_code=$1
              if [ "$exit_code" -eq 0 ]; then
                ntfy_notify "${jobName}" "Finished successfully" "white_check_mark"
              else
                ntfy_notify "${jobName}" "Failed (exit $exit_code). See journalctl --user -u ${jobName}" "x" "high"
              fi
              rm -rf -- "$workdir"
            }
            trap 'finish $?' EXIT

            lockfile="''${XDG_RUNTIME_DIR:-/tmp}/gog-lgogdownloader.lock"
            exec {lock_fd}>"$lockfile"
            flock --wait 21600 "$lock_fd"
            ntfy_notify "${jobName}" "Started" "arrow_forward"

            fail_on_cache_error() {
              if grep -qE "^(Cache doesn't exist|Cache is too old|Cache version doesn't match|Failed to save cache)"; then
                echo "lgogdownloader game details cache is unusable" >&2
                exit 1
              fi
            }

            run_download() {
              local output failures
              output=$(lgogdownloader "$@" --report="$report" </dev/null 2>&1 | tee >(cat 1>&2))
              fail_on_cache_error <<<"$output"

              failures=$(
                {
                  sed -nE 's/^.*Download complete \((.*)\): (.+)$/\2 (\1)/p' "$report"
                  grep -E 'Failed to|failed' "$report" | grep -v 'Download complete' |
                    sed -E 's/^[0-9]{4}-[A-Za-z]{3}-[0-9]{2} [0-9:.]+: //'
                  grep -E 'Not enough free space' <<<"$output"
                } | sort -u || true
              )
              if [ -n "$failures" ]; then
                {
                  echo "download finished with problems:"
                  printf '%s\n' "$failures"
                } >&2
                exit 1
              fi
              echo "downloaded $(grep -c 'Download complete: ' "$report" || true) file(s)"
            }

            game_filter() {
              local filter="" escaped name
              for name in "$@"; do
                escaped=$(printf '%s' "$name" | sed -E 's/[][\.^$*+?(){}|]/\\&/g')
                filter="''${filter:+$filter|}$escaped"
              done
              printf '^(%s)$' "$filter"
            }
          '';
          mkScript =
            name: text:
            pkgs.writeShellApplication {
              inherit name;
              excludeShellChecks = [ "SC2329" ];
              runtimeInputs = with pkgs; [
                coreutils
                curl
                findutils
                gnugrep
                gnused
                util-linux
                lgogdownloader
              ];
              text = ''
                ${mkCommonHelpers name}
                ${text}
              '';
            };
          mkService = script: description: {
            Service = {
              ExecStart = lib.getExe script;
              IOSchedulingClass = "idle";
              Nice = 19;
              Type = "oneshot";
            };
            Unit.Description = description;
          };
          newGamesMaxBatch = 100;
          newGamesSkipFile = "${config.xdg.stateHome}/gog-new-games/no-files";
          ntfyHelpers = self.lib.mkNtfyNotify {
            click = true;
            token = "$(cat ${lib.escapeShellArg config.sops.secrets."ntfy/ntfybot_token".path})";
            topicUrl = "http://${self.lib.site.network.hosts.regret}/gog";
          };
          orphanDirectoryFractionThreshold = 75;
          orphanMaxFiles = 300;
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
              gog-full-download =
                lib.recursiveUpdate
                  (mkService gog-full-download "Refresh GOG library details and download new or updated files")
                  {
                    Unit.OnSuccess = [ "gog-remove-orphans.service" ];
                  };
              gog-new-games = mkService gog-new-games "Download owned GOG games that have no local directory yet";
              gog-remove-orphans = mkService gog-remove-orphans "Delete local GOG files no longer present on GOG servers";
            };
            timers = {
              gog-full-download = {
                Install.WantedBy = [ "timers.target" ];
                Timer = {
                  OnCalendar = "Sun *-*-* 03:00:00";
                  Persistent = true;
                  RandomizedDelaySec = "30m";
                };
                Unit.Description = "Weekly GOG library download, followed by orphan cleanup";
              };
              gog-new-games = {
                Install.WantedBy = [ "timers.target" ];
                Timer = {
                  OnCalendar = "*-*-* 10:00:00 America/Chicago";
                  Persistent = true;
                };
                Unit.Description = "Daily download of newly owned GOG games";
              };
            };
          };
          xdg.configFile = {
            "lgogdownloader/blacklist.txt".source = gogBlacklistFile;
            "lgogdownloader/config.cfg" = {
              force = true;
              text = lib.concatStrings (
                lib.mapAttrsToList (name: value: "${name} = ${toString value}\n") {
                  automatic-xml-creation = "true";
                  check-free-space = "true";
                  chunk-size = 10;
                  directory = gogDirectory;
                  exclude = "l,p";
                  ignore-dlc-count = ".*";
                  include = "all";
                  include-hidden-products = "true";
                  info-threads = 4;
                  interface = osConfig.host.lanInterface;
                  language = "en";
                  lowspeed-rate = 200;
                  lowspeed-timeout = 30;
                  no-color = "true";
                  no-unicode = "true";
                  no-window-progress = "true";
                  platform = "w";
                  retries = 3;
                  save-changelogs = "true";
                  save-game-details-json = "true";
                  save-serials = "true";
                  subdir-dlc = "dlc/%dlcname%";
                  subdir-extras = "extras";
                  subdir-game = "%gamename%";
                  subdir-installers = "";
                  subdir-language-packs = "languagepacks";
                  subdir-patches = "patches";
                  threads = 4;
                  timeout = 10;
                  unit-format = "IEC";
                  verbosity = -1;
                  xml-directory = "${config.xdg.stateHome}/lgogdownloader/xml";
                }
              );
            };
            "lgogdownloader/ignorelist.txt".source = gogIgnorelistFile;
          };
        };
    };
}
