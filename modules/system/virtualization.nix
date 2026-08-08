{
  flake.modules.nixos = {
    desktop-profile.programs.virt-manager.enable = true;

    virtualization =
      { config, pkgs, ... }:
      {
        boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

        environment.systemPackages = with pkgs; [
          podlet
          quickemu
          spice
          virtio-win
          virtiofsd
          win-spice
        ];

        networking.firewall.trustedInterfaces = [ "virbr0" ];

        preservation.preserveAt."/persist".directories = [
          "/var/lib/containers"
          "/var/lib/libvirt"
          "/var/lib/qemu"
        ];

        services = {
          qemuGuest.enable = true;
          spice-vdagentd.enable = true;
        };

        systemd.tmpfiles.rules = [ "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware" ];

        users.users = {
          ${config.my.user}.extraGroups = [
            "kvm"
            "libvirtd"
            "podman"
          ];
        };

        virtualisation = {
          containers.enable = true;

          libvirtd = {
            # Make sure you run this once: "sudo virsh net-autostart default"
            enable = true;

            qemu = {
              swtpm.enable = true;
              vhostUserPackages = with pkgs; [ virtiofsd ];
            };
          };

          podman = {
            enable = true;
            defaultNetwork.settings.dns_enabled = true;
            dockerCompat = true;
            dockerSocket.enable = true;
          };

          spiceUSBRedirection.enable = true;

          vmVariant.virtualisation = {
            cores = 3;
            memorySize = 4096;
          };
        };
      };
  };
}
