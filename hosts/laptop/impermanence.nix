{
  environment = {
    persistence = {
      "/persist" = {
        hideMounts = true;
        directories = [
          "/etc/mullvad-vpn"
          "/etc/NetworkManager/system-connections"
          "/etc/secureboot"
          "/etc/wireguard"
          "/var/db/sudo/lectured"
          "/var/lib/AccountsService"
          "/var/lib"
          "/var/log"
        ];
        files = [
          "/etc/machine-id"
          "/etc/nix/id_rsa"
          "/etc/ssh/ssh_host_ed25519_key"
          "/etc/ssh/ssh_host_ed25519_key.pub"
          "/etc/ssh/ssh_host_rsa_key"
          "/etc/ssh/ssh_host_rsa_key.pub"
        ];
      };
    };
  };
}
