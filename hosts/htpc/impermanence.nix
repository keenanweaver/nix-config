{
  environment = {
    persistence = {
      "/persist" = {
        hideMounts = true;
        directories = [
          "/etc/NetworkManager/system-connections"
          "/var/db/sudo/lectured"
          "/var/lib/AccountsService"
          "/var/lib/bluetooth"
          "/var/lib/docker"
          "/var/lib/flatpak"
          "/var/lib/libvirt"
          "/var/lib/nixos"
          "/var/lib/systemd/coredump"
          "/var/lib/upower"
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
