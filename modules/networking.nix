{
  flake.modules.nixos.base-profile = {
    networking = {
      hosts = {
        "10.20.1.1" = [
          "opnsense"
        ];
        "10.20.1.7" = [
          "UCK-G2"
        ];
        "10.20.20.11" = [
          "bazzite"
        ];
        "10.20.20.13" = [
          "crusader"
        ];
        "10.20.20.15" = [
          "bazzite-htpc"
        ];
        "10.20.20.17" = [
          "nixos-unraid"
        ];
        "10.20.20.29" = [
          "MiSTer"
        ];
        "10.20.20.30" = [
          "remorsepi"
        ];
        "10.20.20.31" = [
          "regretpi"
        ];
        "10.20.20.32" = [
          "vagabondpi"
        ];
        "10.20.20.33" = [
          "maniacpi"
        ];
      };
      networkmanager = {
        enable = true;
      };
      nftables = {
        enable = true;
      };
      wireguard.enable = true;
    };
    preservation.preserveAt."/persist".directories = [
      "/etc/NetworkManager/system-connections"
      "/etc/wireguard"
      "/var/lib/NetworkManager"
    ];
    services.resolved = {
      enable = true;
      settings = {
        Resolve = {
          FallbackDNS = [
            "9.9.9.9"
            "149.112.112.112"
            "2620:fe::fe"
            "2620:fe::9"
          ];
          LLMNR = "false";
        };
      };
    };
  };
}
