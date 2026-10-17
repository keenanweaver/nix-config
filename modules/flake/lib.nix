{ lib, ... }:
let
  mkDataOption =
    description:
    lib.mkOption {
      inherit description;
      default = { };
      type = lib.types.lazyAttrsOf lib.types.raw;
    };
in
{
  config.flake.lib = {
    mkCacheSettings = caches: {
      extra-substituters = map (cache: cache.url) caches;
      extra-trusted-public-keys = map (cache: cache.key) caches;
    };
    mkNtfyNotify =
      {
        token,
        url,
        click ? false,
      }:
      let
        headers = [
          "Title: $title"
          "Tags: $tags"
          "Priority: $priority"
        ]
        ++ lib.optional click "Click: ${url}";
      in
      ''
        ntfy_notify() {
          local title="$1" message="$2" tags="$3" priority="''${4:-default}"
          curl -fsS \
            --header @<(printf 'Authorization: Bearer %s\n' "${token}") \
            ${lib.concatMapStrings (header: ''--header "${header}" '') headers}\
            --data "$message" \
            "${url}" >/dev/null || true
        }
      '';
    packageListText =
      pkgs: packages:
      builtins.concatStringsSep "\n" (
        builtins.sort builtins.lessThan (pkgs.lib.lists.unique (map (p: p.name) packages))
      );
    systemdSandbox = {
      CapabilityBoundingSet = "";
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      PrivateDevices = true;
      PrivateTmp = true;
      ProcSubset = "pid";
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = "tmpfs";
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      ProtectSystem = "strict";
      RestrictAddressFamilies = [
        "AF_UNIX"
        "AF_INET"
        "AF_INET6"
        "AF_NETLINK"
      ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
      SystemCallErrorNumber = "EPERM";
      SystemCallFilter = [
        "@system-service"
        "~@privileged"
      ];
      UMask = "0077";
    };
  };
  options = {
    caches = lib.mkOption {
      default = { };
      description = "Binary caches, keyed by name, for aspects and hosts to share via mkCacheSettings.";
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            key = lib.mkOption { type = lib.types.str; };
            url = lib.mkOption { type = lib.types.str; };
          };
        }
      );
    };
    flake.lib = lib.mkOption {
      default = { };
      description = "Helper functions shared across modules.";
      type = lib.types.lazyAttrsOf lib.types.raw;
    };
    roms = mkDataOption "Game ROM dumps";
    site = mkDataOption "Facts";
    theme = mkDataOption "Look and feel";
  };
}
