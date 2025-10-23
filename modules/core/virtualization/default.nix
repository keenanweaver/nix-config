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
        dockerCompat = false;
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
            "docker"
            "kvm"
            "libvirtd"
            "podman"
          ];
        };

        nixosvmtest = {
          isSystemUser = true;
          hashedPasswordFile = config.sops.secrets.pass.path;
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
