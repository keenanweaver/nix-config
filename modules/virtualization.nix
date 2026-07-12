{
  flake.modules = {
    nixos.base-profile = { config, pkgs, ... }: {
      boot = {
        extraModprobeConfig = ''
          options kvm_amd nested=1
          options kvm ignore_msrs=1 report_ignored_msrs=0
        '';
        kernel.sysctl = {
          "net.ipv4.ip_forward" = 1;
        };
      };

      environment = {
        systemPackages = with pkgs; [
          #docker-compose
          podlet
          quickemu
          spice
          spice-protocol
          virtiofsd
          virtio-win
          win-spice
        ];
      };

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
        ${config.my.user} = {
          extraGroups = [
            "kvm"
            "libvirtd"
            "podman"
          ];
        };
      };

      virtualisation = {
        containers = {
          enable = true;
        };
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
        vmVariant = {
          virtualisation = {
            cores = 3;
            memorySize = 4096;
          };
        };
      };
    };
    nixos.virtualization = {
      programs.virt-manager.enable = true;
    };
  };
}
