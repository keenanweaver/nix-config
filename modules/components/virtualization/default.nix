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
        #docker-compose
        #podman-compose
        quickemu
        spice
        spice-protocol
        virt-manager
        virtiofsd
        win-virtio
        win-spice
      ];
    };
    # https://github.com/NixOS/nixpkgs/issues/226365
    networking.firewall.interfaces."podman+".allowedUDPPorts = [
      53
      5353
    ];
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
    };

    users.users.${username}.extraGroups = [
      "docker"
      "libvirtd"
    ];

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
