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
          ...
        }:
        let
          fanMissionsDirectory = self.lib.site.nas.paths.thiefFanMissions;
          # Game icon in the ttlg.de listing -> folder under the fan missions directory. Thief 1
          # missions play in Thief Gold, so they share its folder. The Dark Mod (no icon) is skipped.
          games = {
            Thief1 = "Thief Gold";
            Thief1G = "Thief Gold";
            Thief2 = "Thief 2";
            Thief3 = "Thief 3";
          };
          ntfyHelpers = self.lib.mkNtfyNotify {
            click = true;
            token = "$(cat ${lib.escapeShellArg config.sops.secrets."ntfy/ntfybot_token".path})";
            topicUrl = "http://${self.lib.site.network.hosts.regret}/downloaders";
          };
          ttlg-sync = pkgs.writeShellApplication {
            excludeShellChecks = [ "SC2329" ];
            name = "ttlg-sync";
            runtimeInputs = with pkgs; [
              coreutils
              curl
              gawk
              gnugrep
              gnused
              wget
            ];
            text = ''
              ${ntfyHelpers}
              fm_dir=${lib.escapeShellArg fanMissionsDirectory}
              workdir=$(mktemp -d)
              logfile="$workdir/wget.log"
              final_status=""

              notify_finish() {
                local exit_code=$1
                local status="''${final_status:-$exit_code}"
                local downloaded
                downloaded=$(grep -c ' -> "' "$logfile" 2>/dev/null || true)
                case "$status" in
                  ok)
                    ntfy_notify "ttlg.de sync" "Finished successfully. Downloaded ''${downloaded:-0} file(s)." "white_check_mark"
                    ;;
                  partial)
                    ntfy_notify "ttlg.de sync" "Finished. Downloaded ''${downloaded:-0} file(s); some missions could not be fetched:
              $(cat "$workdir/problems" 2>/dev/null)
              $(grep -B1 'ERROR' "$logfile" | grep -oE '^https://[^ ]+:$' | sed 's/:$//' | sort -u)" "warning"
                    ;;
                  *)
                    ntfy_notify "ttlg.de sync" "Failed (exit $status). See journalctl --user -u ttlg-sync" "x" "high"
                    ;;
                esac
                rm -rf -- "$workdir"
              }
              trap 'notify_finish $?' EXIT
              ntfy_notify "ttlg.de sync" "Started" "arrow_forward"

              if [ ! -d "$fm_dir" ]; then
                echo "$fm_dir does not exist (NAS not mounted?)" >&2
                exit 1
              fi
              ${self.lib.mullvadTunnel.requireAddress}

              fetch() {
                curl -fsSL --retry 3 --interface "$vpn_address" "$@"
              }

              # The listing is one page with a row per mission: its detail page id and a game icon.
              fetch -o "$workdir/listing.html" 'https://www.ttlg.de/index.php?fm-download/'
              tr -d '\r\n' <"$workdir/listing.html" | sed 's#</tr>#</tr>\n#g' |
                sed -nE 's#.*fm-detail&(amp;)?id=([0-9]+).*images/de/(${lib.concatStringsSep "|" (builtins.attrNames games)})\.png.*#\2\t\3#p' |
                sort -u -t "$(printf '\t')" -k1,1n >"$workdir/missions.tsv"
              missions=$(wc -l <"$workdir/missions.tsv")
              if [ "$missions" -lt 500 ]; then
                echo "found only $missions missions on ttlg.de; the site layout may have changed" >&2
                exit 1
              fi
              echo "found $missions Thief fan missions on ttlg.de"

              # Each detail page lists the mission's files as download.php links. Some hrefs end in a
              # line break, and file names come either URL-encoded or with literal spaces.
              : >"$workdir/problems"
              while IFS=$'\t' read -r id icon; do
                case "$icon" in
                  ${lib.concatStrings (
                    lib.mapAttrsToList (icon: folder: "${icon}) dest=${lib.escapeShellArg folder} ;; ") games
                  )}
                esac
                sleep 1
                if ! fetch -o "$workdir/detail.html" "https://www.ttlg.de/index.php?fm-detail/&id=$id"; then
                  echo "mission $id: could not fetch its page" >>"$workdir/problems"
                  continue
                fi
                urls=$(tr -d '\r\n' <"$workdir/detail.html" |
                  grep -oE 'download/download\.php\?site=[0-9]+&amp;file=[^"]+' |
                  sed -E 's/&amp;/\&/; s/[[:space:]]+$//; s/ /%20/g; s#^#https://www.ttlg.de/#' || true)
                if [ -z "$urls" ]; then
                  echo "mission $id: no download on ttlg.de (https://www.ttlg.de/index.php?fm-detail/&id=$id)" >>"$workdir/problems"
                  continue
                fi
                printf '%s\n' "$urls" | awk -v dest="$dest" '{ print dest "\t" $0 }'
              done <"$workdir/missions.tsv" | sort -u >"$workdir/files.tsv"
              echo "found $(wc -l <"$workdir/files.tsv") file(s) to check"

              wget_rc=0
              cut -f1 "$workdir/files.tsv" | sort -u >"$workdir/destinations"
              while IFS= read -r dest; do
                awk -F '\t' -v dest="$dest" '$1 == dest { print $2 }' "$workdir/files.tsv" >"$workdir/urls"
                rc=0
                wget ${lib.escapeShellArgs wgetArgs} --bind-address="$vpn_address" -P "$fm_dir/$dest" \
                  -i "$workdir/urls" 2>&1 | tee -a "$logfile" || rc=''${PIPESTATUS[0]}
                if [ "$rc" -ne 0 ] && [ "$rc" -ne 8 ]; then
                  exit "$rc"
                fi
                if [ "$rc" -eq 8 ]; then
                  wget_rc=8
                fi
              done <"$workdir/destinations"

              if [ "$wget_rc" -eq 8 ] || [ -s "$workdir/problems" ]; then
                final_status=partial
              else
                final_status=ok
              fi
            '';
          };
          wgetArgs = [
            "--timestamping"
            "--content-disposition"
            "--no-verbose"
            "--tries=3"
            "--timeout=30"
            "--wait=1"
            "--random-wait"
          ];
        in
        {
          home.packages = [ ttlg-sync ];
          sops.secrets."ntfy/ntfybot_token" = { };
          systemd.user = {
            services.ttlg-sync = {
              Service = {
                ExecStart = lib.getExe ttlg-sync;
                IOSchedulingClass = "idle";
                Nice = 19;
                Type = "oneshot";
              };
              Unit.Description = "Download Thief, Thief Gold, Thief 2 and Thief 3 fan missions from ttlg.de";
            };
            timers.ttlg-sync = {
              Install.WantedBy = [ "timers.target" ];
              Timer = {
                # Same days as rtsl-sync's "quarterly", a few hours later so the two don't overlap.
                OnCalendar = "*-01,04,07,10-01 03:00:00";
                Persistent = true;
                RandomizedDelaySec = "1h";
              };
              Unit.Description = "Quarterly ttlg.de fan mission download";
            };
          };
        };
    };
}
