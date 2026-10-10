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
          downloadDirectory = "${self.lib.site.nas.paths.thiefFanMissions}/Thievery Customs";
          # Fan Mission Pack Generator game ids: Thief 1, Thief 2, Thief 3.
          games = [
            "14"
            "24"
            "34"
          ];
          ntfyHelpers = self.lib.mkNtfyNotify {
            click = true;
            token = "$(cat ${lib.escapeShellArg config.sops.secrets."ntfy/ntfybot_token".path})";
            topicUrl = "http://${self.lib.site.network.hosts.regret}/downloaders";
          };
          thievery-customs-sync = pkgs.writeShellApplication {
            excludeShellChecks = [ "SC2329" ];
            name = "thievery-customs-sync";
            runtimeInputs = with pkgs; [
              coreutils
              curl
              gawk
              gnugrep
              gnused
              jq
            ];
            text = ''
              ${ntfyHelpers}
              dest=${lib.escapeShellArg downloadDirectory}
              site=https://thievery-customs.com
              workdir=$(mktemp -d)
              jar="$workdir/cookies"
              final_status=""
              : >"$workdir/downloaded"
              : >"$workdir/problems"

              notify_finish() {
                local exit_code=$1
                local status="''${final_status:-$exit_code}"
                local downloaded
                downloaded=$(wc -l <"$workdir/downloaded" 2>/dev/null || echo 0)
                case "$status" in
                  ok)
                    ntfy_notify "Thievery Customs sync" "Finished successfully. Downloaded $downloaded file(s)." "white_check_mark"
                    ;;
                  partial)
                    ntfy_notify "Thievery Customs sync" "Finished. Downloaded $downloaded file(s); some missions could not be fetched:
              $(head -n 20 "$workdir/problems")" "warning"
                    ;;
                  *)
                    ntfy_notify "Thievery Customs sync" "Failed (exit $status). See journalctl --user -u thievery-customs-sync" "x" "high"
                    ;;
                esac
                rm -rf -- "$workdir"
              }
              trap 'notify_finish $?' EXIT
              ntfy_notify "Thievery Customs sync" "Started" "arrow_forward"

              if [ ! -d "$(dirname "$dest")" ]; then
                echo "$(dirname "$dest") does not exist (NAS not mounted?)" >&2
                exit 1
              fi
              mkdir -p "$dest"
              ${self.lib.mullvadTunnel.requireAddress}

              fetch() {
                curl -fsSL --retry 3 --interface "$vpn_address" -A "Mozilla/5.0" -b "$jar" -c "$jar" "$@"
              }

              csrf_token() {
                grep -oE 'name="csrf_token" value="[0-9a-f]+"' "$1" | head -n 1 | grep -oE '[0-9a-f]{20,}'
              }

              # The generator page embeds every matching mission as JSON (window.fmgenData.allItems).
              # Submitting it per game with the collector edition lists every version of every mission.
              fetch -o "$workdir/page.html" "$site/ttlg"
              token=$(csrf_token "$workdir/page.html")
              : >"$workdir/names.tsv"
              : >"$workdir/sources.tsv"
              for cat in ${lib.escapeShellArgs games}; do
                fetch -o "$workdir/page.html" "$site/ttlg" \
                  --data-urlencode "csrf_token=$token" \
                  --data "cat=$cat&search_field=title&edition=collector"
                token=$(csrf_token "$workdir/page.html")
                sed -nE 's/^[[:space:]]*allItems:[[:space:]]*//; T; s/,[[:space:]]*$//; p' "$workdir/page.html" >"$workdir/items.json"
                count=$(jq length "$workdir/items.json")
                echo "game $cat: $count mission file(s)"
                if [ "$count" -eq 0 ]; then
                  echo "game $cat returned no missions; the site layout may have changed" >&2
                  exit 1
                fi
                jq -r '.[] | "\(.id)\t\(.filename | split("/") | last | sub("\\.[^.]*$"; ""))"' "$workdir/items.json" >>"$workdir/sources.tsv"

                # The site's own .bat generator names each file like
                # "T2 FM <Title> [<date>] <version> (<languages>).zip"; ask it for those names.
                # It only reads the first 1000 missions of a request, so ask in batches.
                before=$(wc -l <"$workdir/names.tsv")
                jq -c 'range(0; length; 900) as $i | .[$i:$i + 900]' "$workdir/items.json" >"$workdir/batches"
                while IFS= read -r batch; do
                  {
                    printf 'meta=%s' "$(jq -r '{filenameMode: "generated", edition: "collector", selectedCount: length} | tojson | @uri' <<<"$batch")"
                    jq -r '.[] | {id, cat, filename, title, version, created, updated, en, de, fr, es, it, nl, pl, cs, hu, ru} | "&missions%5B%5D=" + (tojson | @uri)' <<<"$batch" | tr -d '\n'
                  } >"$workdir/request"
                  fetch -o "$workdir/download.bat" "$site/xtra/ttlg/ttlg_bat.php" --data-binary "@$workdir/request"
                  tr -d '\r' <"$workdir/download.bat" |
                    awk -F '"' '/^curl / && match($4, /[?&]id=[0-9]+/) {
                      name = $2; sub(/^%BaseDir%\\[^\\]*\\/, "", name)
                      print substr($4, RSTART + 4, RLENGTH - 4) "\t" name
                    }' >>"$workdir/names.tsv"
                done <"$workdir/batches"
                named=$(($(wc -l <"$workdir/names.tsv") - before))
                if [ "$named" -ne "$count" ]; then
                  echo "game $cat: got names for $named of $count mission file(s)" >&2
                  exit 1
                fi
              done

              # Different uploads of the same mission can share a generated name; tell those apart
              # with the archive's original file name.
              awk -F '\t' '
                NR == FNR { source[$1] = $2; next }
                { id[FNR] = $1; name[FNR] = $2; seen[$2]++; n = FNR }
                END {
                  for (i = 1; i <= n; i++) {
                    file = name[i]
                    if (seen[file] > 1) {
                      if (match(file, /\.[^.]+$/))
                        file = substr(file, 1, RSTART - 1) " [" source[id[i]] "]" substr(file, RSTART)
                      else
                        file = file " [" source[id[i]] "]"
                    }
                    print id[i] "\t" file
                  }
                }' "$workdir/sources.tsv" "$workdir/names.tsv" >"$workdir/files.tsv"
              total=$(wc -l <"$workdir/files.tsv")
              if [ "$total" -lt 1000 ]; then
                echo "found only $total mission file(s); the site layout may have changed" >&2
                exit 1
              fi
              echo "found $total mission file(s) in total"

              # File names carry the version and date, so anything already on disk is complete.
              while IFS=$'\t' read -r id name; do
                [ -e "$dest/$name" ] && continue
                sleep 1
                if fetch --retry-delay 5 --retry-connrefused -C - -o "$dest/$name.part" \
                  "$site/xtra/ttlg/ttlg_dl.php?id=$id"; then
                  mv -- "$dest/$name.part" "$dest/$name"
                  echo "downloaded: $name"
                  echo "$name" >>"$workdir/downloaded"
                else
                  echo "mission $id ($name): download failed" | tee -a "$workdir/problems" >&2
                fi
              done <"$workdir/files.tsv"

              if [ -s "$workdir/problems" ]; then
                final_status=partial
              else
                final_status=ok
              fi
            '';
          };
        in
        {
          home.packages = [ thievery-customs-sync ];
          sops.secrets."ntfy/ntfybot_token" = { };
          systemd.user = {
            services.thievery-customs-sync = {
              Service = {
                ExecStart = lib.getExe thievery-customs-sync;
                IOSchedulingClass = "idle";
                Nice = 19;
                Type = "oneshot";
              };
              Unit.Description = "Download every version of every Thief fan mission from Thievery Customs";
            };
            timers.thievery-customs-sync = {
              Install.WantedBy = [ "timers.target" ];
              Timer = {
                OnCalendar = "*-01,04,07,10-01 09:00:00";
                Persistent = true;
                RandomizedDelaySec = "1h";
              };
              Unit.Description = "Quarterly Thievery Customs fan mission download";
            };
          };
        };
    };
}
