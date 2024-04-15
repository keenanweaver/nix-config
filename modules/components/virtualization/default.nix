{ inputs, home-manager, lib, config, pkgs, username, ... }: with lib;
let
  cfg = config.virtualization;
in
{
  options = {
    virtualization = {
      enable = mkEnableOption "Enable virtualization in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        docker-compose
        podman-compose
        spice
        spice-protocol
        virt-manager
        virtiofsd
        win-virtio
        win-spice
      ];
    };
    services = {
      spice-vdagentd.enable = true;
    };
    virtualisation = {
      /*     lxc = {
      enable = true;
      lxcfs.enable = true;
      };
        lxd.enable = true; */
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
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: { };
  };
}
