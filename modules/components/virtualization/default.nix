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
    environment = {
      systemPackages = with pkgs; [
        quickemu
        spice
        spice-protocol
        virt-manager
        virtiofsd
        virtio-win
        win-spice
      ];
    };
    services = {
      spice-vdagentd.enable = true;
    };
    virtualisation = {
      # (Make sure you run this once: "sudo virsh net-autostart default")
      podman = {
        enable = true;
        autoPrune = {
          enable = true;
          dates = "weekly";
        };
        defaultNetwork.settings.dns_enabled = true;
        dockerCompat = true;
        dockerSocket.enable = true;
        enableNvidia = if vars.nvidia then true else false;
      };
      libvirtd = {
        enable = true;
        qemu = {
          swtpm.enable = true;
          ovmf.enable = true;
          ovmf.packages = [ pkgs.OVMFFull.fd ];
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

    users = {
      users = {
        ${username}.extraGroups = [
          "docker"
          "libvirtd"
        ];
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

    home-manager.users.${username} = {
      dconf.settings = {
        "org/virt-manager/virt-manager/connections" = {
          autoconnect = [ "qemu:///system" ];
          uris = [ "qemu:///system" ];
        };
      };
    };
  };
}
