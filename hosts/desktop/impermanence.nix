{
  environment = {
    persistence = {
      "/persist" = {
        hideMounts = true;
        directories = [
          "/etc/mullvad-vpn"
          "/etc/NetworkManager/system-connections"
          "/etc/opensnitchd"
          "/etc/secureboot"
          "/etc/wireguard"
          "/var/db/sudo/lectured"
          "/var/lib/AccountsService"
          "/var/lib/bluetooth"
          "/var/lib/clamav"
          "/var/lib/docker"
          "/var/lib/flatpak"
          "/var/lib/libvirt"
          "/var/lib/nixos"
          "/var/lib/systemd/coredump"
          "/var/lib/tailscale"
          "/var/lib/upower"
          "/var/lib/zerotier-one"
          "/var/log"
        ];
        files = [
          "/etc/machine-id"
          "/etc/ssh/ssh_host_ed25519_key"
          "/etc/ssh/ssh_host_ed25519_key.pub"
          "/etc/ssh/ssh_host_rsa_key"
          "/etc/ssh/ssh_host_rsa_key.pub"
        ];
      };
    };
  };
}
