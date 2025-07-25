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
    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
    };

    environment = {
      systemPackages = with pkgs; [
        docker-compose
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

    programs.virt-manager.enable = true;

    services = {
      spice-vdagentd.enable = vars.desktop;
      qemuGuest.enable = vars.desktop;
    };

    virtualisation = {
      podman = {
        enable = true;
        autoPrune = {
          enable = true;
          dates = "weekly";
        };
        defaultNetwork.settings.dns_enabled = true;
        #dockerCompat = true;
        #dockerSocket.enable = true;
      };
      libvirtd = {
        # Make sure you run this once: "sudo virsh net-autostart default"
        enable = vars.desktop;
        qemu = {
          swtpm.enable = true;
          ovmf.enable = true;
          ovmf.packages = [ pkgs.OVMFFull.fd ];
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
            "docker"
            "libvirtd"
            "podman"
          ];
        };

        nixosvmtest = {
          isSystemUser = true;
          initialHashedPassword = "$y$j9T$cLVPJpZrtzdgCM732gQ3g/$4qBIUCoDSJ1frFNcvqYSL6ykQSOdjQyDVqRIANx.SRD";
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
