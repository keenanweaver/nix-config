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
          # WordPress category id -> destination under the RunThinkShootLive directory. Posts filed
          # only under a game's parent category are Unsorted until their archive is inspected.
          categories = {
            "170" = "Mods/Blue Shift";
            "614" = "Maps/Half-Life";
            "615" = "Mods/Half-Life";
            "637" = "Maps/Opposing Force";
            "644" = "Mods/Opposing Force";
            "91" = "Unsorted/Half-Life";
            "96" = "Unsorted/Opposing Force";
          };
          categoryIds = lib.concatStringsSep "," (builtins.attrNames categories);
          # Prints "<destination>\t<file url>" for every download linked from a post. download.php
          # just appends its f= parameter to the file host, so the post links are normalised to the
          # file's "<game dir>/<name>" path, which also repairs the few malformed links on the site.
          jqFilter = ''
            .[]
            | (.categories | map(tostring)) as $ids
            | ($ids | map(select(. as $id | $map | has($id))) | map($map[.])
                | (map(select(startswith("Unsorted/") | not)) + .) | first) as $dest
            | select($dest != null)
            | .content.rendered
            | scan("download\\.php\\?id=[0-9]+&(?:#038;|amp;)?f=([^\"]+)")[0]
            | sub("^.*/(?<path>[^/]+/[^/]+)$"; .path)
            | sub("^half=life-1/"; "half-life-1/")
            | "\($dest)\thttps://files.runthinkshootlive.com/\(.)"
          '';
          ntfyHelpers = self.lib.mkNtfyNotify {
            click = true;
            token = "$(cat ${lib.escapeShellArg config.sops.secrets."ntfy/ntfybot_token".path})";
            topicUrl = "http://${self.lib.site.network.hosts.regret}/downloaders";
          };
          rtsl-sync = pkgs.writeShellApplication {
            excludeShellChecks = [ "SC2329" ];
            name = "rtsl-sync";
            runtimeInputs = with pkgs; [
              _7zz-rar
              coreutils
              curl
              gawk
              gnugrep
              gnused
              jq
              wget
            ];
            text = ''
              ${ntfyHelpers}
              rtsl_dir=${lib.escapeShellArg rtslDirectory}
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
                    ntfy_notify "RTSL sync" "Finished successfully. Downloaded ''${downloaded:-0} file(s)." "white_check_mark"
                    ;;
                  partial)
                    ntfy_notify "RTSL sync" "Finished. Downloaded ''${downloaded:-0} file(s); some links are broken on the site:
              $(grep -B1 'ERROR' "$logfile" | grep -oE '^https://[^ ]+:$' | sed 's/:$//' | sort -u)" "warning"
                    ;;
                  *)
                    ntfy_notify "RTSL sync" "Failed (exit $status). See journalctl --user -u rtsl-sync" "x" "high"
                    ;;
                esac
                rm -rf -- "$workdir"
              }
              trap 'notify_finish $?' EXIT
              ntfy_notify "RTSL sync" "Started" "arrow_forward"

              if [ ! -d "$rtsl_dir" ]; then
                echo "$rtsl_dir does not exist (NAS not mounted?)" >&2
                exit 1
              fi
              ${self.lib.mullvadTunnel.requireAddress}

              # Mods ship their own game folder (liblist.gam) or an installer; anything else only adds
              # maps. This matches RTSL's own Maps/Mods split for about 92% of the files it has sorted.
              classify() {
                local file=$1 listing
                case "''${file,,}" in
                  *.exe | *.msi)
                    echo Mods
                    return
                    ;;
                esac
                if ! listing=$(7zz l -ba -- "$file" 2>/dev/null); then
                  echo Mods
                elif grep -qiE '(^|[ /\\])liblist\.gam$|\.(exe|msi)$' <<<"$listing"; then
                  echo Mods
                else
                  echo Maps
                fi
              }

              # Paging in the default date order skips and repeats posts that share a date.
              page=1
              while :; do
                curl -fsS --retry 3 --interface "$vpn_address" -D "$workdir/headers" -o "$workdir/posts-$page.json" \
                  "https://www.runthinkshootlive.com/wp-json/wp/v2/posts?categories=${categoryIds}&orderby=id&order=asc&per_page=100&page=$page&_fields=categories,content"
                total_pages=$(grep -i '^x-wp-totalpages:' "$workdir/headers" | tr -dc '0-9')
                if [ "$page" -ge "''${total_pages:-1}" ]; then
                  break
                fi
                page=$((page + 1))
              done

              # A file linked from both a sorted and an unsorted post keeps the sorted destination.
              jq -rs --argjson map ${lib.escapeShellArg (builtins.toJSON categories)} \
                ${lib.escapeShellArg "add | ${jqFilter}"} "$workdir"/posts-*.json |
                sort -t "$(printf '\t')" -k2,2 -k1,1 | awk -F '\t' '!seen[$2]++' >"$workdir/found.tsv"
              if [ ! -s "$workdir/found.tsv" ]; then
                echo "found no downloads on RunThinkShootLive; the site layout may have changed" >&2
                exit 1
              fi
              echo "found $(wc -l <"$workdir/found.tsv") file(s) on RunThinkShootLive"

              # Unsorted files already sorted on an earlier run are updated where they are; new ones
              # are downloaded into Unsorted and moved to Maps or Mods below.
              while IFS=$'\t' read -r dest url; do
                if [[ $dest == Unsorted/* ]]; then
                  game=''${dest#Unsorted/}
                  name=''${url##*/}
                  for kind in Maps Mods; do
                    if [ -e "$rtsl_dir/$kind/$game/$name" ]; then
                      dest="$kind/$game"
                      break
                    fi
                  done
                fi
                printf '%s\t%s\n' "$dest" "$url"
              done <"$workdir/found.tsv" >"$workdir/files.tsv"

              wget_rc=0
              cut -f1 "$workdir/files.tsv" | sort -u >"$workdir/destinations"
              while IFS= read -r dest; do
                awk -F '\t' -v dest="$dest" '$1 == dest { print $2 }' "$workdir/files.tsv" >"$workdir/urls"
                rc=0
                wget ${lib.escapeShellArgs wgetArgs} --bind-address="$vpn_address" -P "$rtsl_dir/$dest" \
                  -i "$workdir/urls" 2>&1 | tee -a "$logfile" || rc=''${PIPESTATUS[0]}
                if [ "$rc" -ne 0 ] && [ "$rc" -ne 8 ]; then
                  exit "$rc"
                fi
                if [ "$rc" -eq 8 ]; then
                  wget_rc=8
                fi
              done <"$workdir/destinations"

              if [ -d "$rtsl_dir/Unsorted" ]; then
                while IFS= read -r -d "" file; do
                  game=$(basename "$(dirname "$file")")
                  kind=$(classify "$file")
                  mkdir -p "$rtsl_dir/$kind/$game"
                  mv -- "$file" "$rtsl_dir/$kind/$game/"
                  echo "sorted ''${file##*/} into $kind/$game"
                done < <(find "$rtsl_dir/Unsorted" -type f -print0)
                find "$rtsl_dir/Unsorted" -depth -type d -empty -delete
              fi

              if [ "$wget_rc" -eq 8 ]; then
                final_status=partial
              else
                final_status=ok
              fi
            '';
          };
          rtslDirectory = "${self.lib.site.nas.paths.halfLife}/RunThinkShootLive";
          wgetArgs = [
            "--timestamping"
            "--no-directories"
            "--no-verbose"
            "--tries=3"
            "--timeout=30"
            "--wait=1"
            "--random-wait"
          ];
        in
        {
          home.packages = [ rtsl-sync ];
          sops.secrets."ntfy/ntfybot_token" = { };
          systemd.user = {
            services.rtsl-sync = {
              Service = {
                ExecStart = lib.getExe rtsl-sync;
                IOSchedulingClass = "idle";
                Nice = 19;
                Type = "oneshot";
              };
              Unit.Description = "Download Half-Life, Opposing Force and Blue Shift maps and mods from RunThinkShootLive";
            };
            timers.rtsl-sync = {
              Install.WantedBy = [ "timers.target" ];
              Timer = {
                OnCalendar = "quarterly";
                Persistent = true;
                RandomizedDelaySec = "1h";
              };
              Unit.Description = "Quarterly RunThinkShootLive download";
            };
          };
        };
    };
}
