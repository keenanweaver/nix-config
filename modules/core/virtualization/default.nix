{
  lib,
  config,
  pkgs,
  username,
  vars,
  ...
}:
let
  cfg = config.virtualization;
in
{
  options = {
    virtualization = {
      enable = lib.mkEnableOption "Enable virtualization in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
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

    programs.virt-manager.enable = vars.desktop;

    services = {
      spice-vdagentd.enable = vars.desktop;
      qemuGuest.enable = vars.desktop;
    };

    virtualisation = {
      containers = {
        enable = true;
      };
      podman = {
        enable = true;
        defaultNetwork.settings.dns_enabled = true;
        #dockerCompat = true;
        dockerSocket.enable = true;
      };
      libvirtd = {
        # Make sure you run this once: "sudo virsh net-autostart default"
        enable = vars.desktop;
        qemu = {
          swtpm.enable = true;
          vhostUserPackages = with pkgs; [ virtiofsd ];
        };
      };
      spiceUSBRedirection.enable = true;
      vmVariant = {
        virtualisation = {
          memorySize = 4096;
          cores = 3;
        };
      };
    };

    systemd.tmpfiles.rules = [ "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware" ];

    users = {
      users = {
        ${username} = {
          extraGroups = [
            "kvm"
            "libvirtd"
            "podman"
          ];
        };

        nixosvmtest = {
          isSystemUser = true;
          initialHashedPassword = "$y$j9T$B1obD.4xOr/6gJ6FCsu1v/$7axAjbaqRpFR3zGZVbOuCRGUNGJXyRxdavAHIyOdyK.";
          group = "nixosvmtest";
        };
      };
      groups = {
        nixosvmtest = { };
      };
    };

    home-manager.users.${username} = { };
  };
}
