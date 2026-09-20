{
  flake.modules.nixos.profile-base = { config, ... }: {
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
          "nixos-htpc"
        ];
        "10.20.20.20" = [
          "nixos-laptop"
        ];
        "10.20.20.29" = [
          "MiSTer"
        ];
        "10.20.20.30" = [
          "remorse"
        ];
        "10.20.20.31" = [
          "regret"
        ];
        "10.20.20.32" = [
          "vagabond"
        ];
        "10.20.20.33" = [
          "maniac"
        ];
        "10.20.20.5" = [
          "nixos-desktop"
        ];
      };
      networkmanager.enable = true;
      nftables.enable = true;
      wireguard.enable = true;
    };
    preservation.preserveAt."/persist".directories = [
      "/etc/NetworkManager/system-connections"
      "/etc/wireguard"
      "/var/lib/NetworkManager"
    ];
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        addresses = true;
        workstation = true;
      };
    };
    services.resolved.enable = true;
    users.users.${config.my.user}.extraGroups = [
      "networkmanager"
    ];
  };
}
