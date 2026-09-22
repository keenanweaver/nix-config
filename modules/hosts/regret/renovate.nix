{
  configurations.nixos.regret.module =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      ntfyTokenFile = config.sops.secrets."ntfy/ntfybot_token".path;
      renovateNotifyMerged = pkgs.writeShellApplication {
        excludeShellChecks = [ "SC2329" ];
        name = "renovate-notify-merged";
        runtimeInputs = [
          config.systemd.package
          pkgs.curl
          pkgs.jq
        ];
        text = ''
          # shellcheck disable=SC2154 # STATE_DIRECTORY is set by systemd's StateDirectory=
          state_file="$STATE_DIRECTORY/notify-merged-last-sha"
          codeberg_token="$(systemd-creds cat 'SECRET-RENOVATE_TOKEN')"
          ntfy_token="$(systemd-creds cat 'SECRET-NTFY_TOKEN')"

          ntfy_notify() {
            local title="$1" message="$2" tags="$3" priority="''${4:-default}"
            curl -fsS \
              --header "Authorization: Bearer $ntfy_token" \
              --header "Title: $title" \
              --header "Tags: $tags" \
              --header "Priority: $priority" \
              --data "$message" \
              "http://10.20.20.31/renovate" >/dev/null || true
          }

          commits=$(curl -fsS \
            --header "Authorization: token $codeberg_token" \
            "https://codeberg.org/api/v1/repos/Keenan/nix-config/commits?sha=dendritic&limit=50")

          current_sha=$(printf '%s' "$commits" | jq -r '.[0].sha')

          if [ ! -f "$state_file" ]; then
            echo "$current_sha" > "$state_file"
            echo "no prior state; recording current dendritic HEAD ($current_sha) without notifying"
            exit 0
          fi
          last_sha=$(cat "$state_file")

          if [ "$current_sha" = "$last_sha" ]; then
            echo "dendritic unchanged ($current_sha)"
            exit 0
          fi

          new_commits=$(printf '%s' "$commits" | jq -c --arg last "$last_sha" '
            (([.[] | .sha] | index($last)) // length) as $idx
            | [.[0:$idx][] | select(.author.login == "Keenan-Renovate")]
            | reverse
          ')

          echo "$current_sha" > "$state_file"

          count=$(printf '%s' "$new_commits" | jq 'length')
          if [ "$count" -eq 0 ]; then
            echo "no new renovate-authored commits on dendritic (last seen $last_sha)"
            exit 0
          fi

          printf '%s' "$new_commits" | jq -c '.[]' | while IFS= read -r c; do
            sha=$(printf '%s' "$c" | jq -r '.sha[0:8]')
            subject=$(printf '%s' "$c" | jq -r '.commit.message | split("\n")[0]')
            echo "notifying: $sha $subject"
            ntfy_notify "Renovate" "$sha: $subject" "white_check_mark"
          done
        '';
      };
    in
    {
      nix.settings.allowed-users = lib.mkDefault [ "renovate" ];
      services.renovate = {
        enable = true;
        credentials = {
          GITHUB_COM_TOKEN = config.sops.secrets."renovate/github_access_token".path;
          RENOVATE_GIT_PRIVATE_KEY = config.sops.secrets."renovate/git_signing".path;
          RENOVATE_HOST_RULES = config.sops.secrets."renovate/nonfree_host_rules".path;
          RENOVATE_TOKEN = config.sops.secrets."renovate/codeberg_bot_pat".path;
        };
        runtimePackages = with pkgs; [
          nix
          openssh
        ];
        schedule = null;
        settings = {
          autodiscover = false;
          automerge = true;
          automergeType = "branch";
          configMigration = true;
          endpoint = "https://codeberg.org";
          extends = [ "config:recommended" ];
          gitAuthor = "Keenan-Renovate <keenan-renovate@noreply.codeberg.org>";
          ignoreTests = true;
          lockFileMaintenance = {
            enabled = true;
            schedule = [ "at any time" ];
          };
          nix.enabled = true;
          onboardingConfigFileName = "renovate.json";
          optimizeForDisabled = true;
          osvVulnerabilityAlerts = true;
          packageRules = [
            {
              groupName = "flake inputs";
              matchManagers = [ "nix" ];
            }
          ];
          persistRepoData = true;
          platform = "forgejo";
          prConcurrentLimit = 0;
          prHourlyLimit = 0;
          repositories = [ "Keenan/nix-config" ];
        };
        validateSettings = true;
      };
      sops.secrets = {
        "ntfy/ntfybot_token" = { };
        "renovate/codeberg_bot_pat" = { };
        "renovate/git_signing" = { };
        "renovate/github_access_token" = { };
        "renovate/nonfree_host_rules" = { };
      };
      systemd.services = {
        renovate.serviceConfig = {
          ExecStartPost = [ (lib.getExe renovateNotifyMerged) ];
          LoadCredential = [ "SECRET-NTFY_TOKEN:${ntfyTokenFile}" ];
          TimeoutStartSec = "10m";
        };
        renovate-watch-nixos-unstable = {
          description = "Trigger renovate when nixpkgs nixos-unstable advances";
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];
          serviceConfig = {
            ExecStart = lib.getExe (
              pkgs.writeShellApplication {
                name = "renovate-watch-nixos-unstable";
                runtimeInputs = [
                  config.systemd.package
                  pkgs.git
                ];
                text = ''
                  # shellcheck disable=SC2154 # STATE_DIRECTORY is set by systemd's StateDirectory=
                  state_file="$STATE_DIRECTORY/last-sha"
                  current_sha=$(git ls-remote https://github.com/NixOS/nixpkgs.git refs/heads/nixos-unstable | cut -f1)
                  if [ -z "$current_sha" ]; then
                    echo "failed to resolve nixos-unstable HEAD" >&2
                    exit 1
                  fi
                  if [ ! -f "$state_file" ]; then
                    echo "$current_sha" > "$state_file"
                    echo "no prior state; recording nixos-unstable HEAD ($current_sha) without starting renovate"
                    exit 0
                  fi
                  last_sha=$(cat "$state_file")
                  if [ "$current_sha" != "$last_sha" ]; then
                    echo "$current_sha" > "$state_file"
                    echo "nixos-unstable moved: $last_sha -> $current_sha; starting renovate"
                    systemctl start renovate.service
                  else
                    echo "nixos-unstable unchanged ($current_sha)"
                  fi
                '';
              }
            );
            StateDirectory = "renovate-watch-nixos-unstable";
            Type = "oneshot";
          };
          startAt = "hourly";
        };
      };
    };
}
