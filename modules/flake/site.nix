{ lib, ... }:
let
  nasMountRoot = "/mnt/crusader";
in
{
  flake.lib = {
    mkNtfyNotify =
      {
        token,
        topicUrl,
        click ? false,
      }:
      let
        headers = [
          "Authorization: Bearer ${token}"
          "Title: $title"
          "Tags: $tags"
          "Priority: $priority"
        ]
        ++ lib.optional click "Click: ${topicUrl}";
      in
      ''
        ntfy_notify() {
          local title="$1" message="$2" tags="$3" priority="''${4:-default}"
          curl -fsS \
            ${lib.concatMapStrings (header: ''--header "${header}" '') headers}\
            --data "$message" \
            "${topicUrl}" >/dev/null || true
        }
      '';
    site = {
      location = {
        latitude = 41.117901;
        longitude = -95.910009;
      };
      nas = {
        host = "crusader";
        mountRoot = nasMountRoot;
        paths = {
          gogBackups = "${nasMountRoot}/Games/Backups/GOG";
          idgames = "${nasMountRoot}/Games/Games/Doom/idgames";
        };
      };
      network = {
        gateway = "10.20.20.1";
        hosts = {
          MiSTer = "10.20.20.29";
          UCK-G2 = "10.20.1.7";
          bazzite = "10.20.20.11";
          crusader = "10.20.20.13";
          maniac = "10.20.20.33";
          nixos-desktop = "10.20.20.5";
          nixos-htpc = "10.20.20.15";
          nixos-laptop = "10.20.20.20";
          opnsense = "10.20.1.1";
          regret = "10.20.20.31";
          remorse = "10.20.20.30";
          vagabond = "10.20.20.32";
        };
        sshPort = 6777;
      };
    };
  };
}
