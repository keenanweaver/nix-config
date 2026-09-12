{
  configurations.nixos.nixos-laptop.module =
    { config, ... }:
    {
      networking.networkmanager = {
        enable = true;
        ensureProfiles = {
          environmentFiles = [ config.sops.templates."networkmanager.env".path ];
          profiles = {
            Vagabond_USER = {
              connection = {
                autoconnect = true;
                id = "Vagabond_USER";
                type = "wifi";
              };
              ipv4.method = "auto";
              ipv6.method = "auto";
              wifi = {
                mode = "infrastructure";
                ssid = "Vagabond_USER";
              };
              wifi-security = {
                auth-alg = "open";
                key-mgmt = "wpa-psk";
                psk = "$PSK_VAGABOND_USER";
              };
            };
            Weaver = {
              connection = {
                autoconnect = true;
                id = "Weaver";
                type = "wifi";
              };
              ipv4.method = "auto";
              ipv6.method = "auto";
              wifi = {
                mode = "infrastructure";
                ssid = "Weaver";
              };
              wifi-security = {
                auth-alg = "open";
                key-mgmt = "wpa-psk";
                psk = "$PSK_WEAVER";
              };
            };
          };
        };
      };
      sops = {
        secrets = {
          "wireless/Vagabond_USER" = { };
          "wireless/Weaver" = { };
        };
        templates."networkmanager.env" = {
          content = ''
            PSK_VAGABOND_USER=${config.sops.placeholder."wireless/Vagabond_USER"}
            PSK_WEAVER=${config.sops.placeholder."wireless/Weaver"}
          '';
          restartUnits = [ "NetworkManager.service" ];
        };
      };
    };
}
