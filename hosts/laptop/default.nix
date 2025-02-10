{
  lib,
  username,
  ...
}:
{
  imports = [
    # System
    ./disko.nix
    ./hardware-configuration.nix
    ./impermanence.nix
    # Profiles
    ../../modules
    # Plasma
    ../../modules/desktop-environments/kde/plasma-manager/laptop.nix
  ];

  # Custom modules
  desktop.enable = true;

  boot = {
    initrd.availableKernelModules = lib.mkDefault [
      "xhci_pci"
      "ahci"
      "nvme"
      "usb_storage"
      "usbhid"
      "sd_mod"
    ];
    kernelModules = lib.mkDefault [
      "tcp_bbr"
      "kvm-amd"
    ];
    kernelParams = lib.mkDefault [
      "amd_iommu=on"
      "amd_pstate=guided"
    ];
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
  };

  networking = {
    firewall = {
      allowedUDPPorts = [ 51821 ]; # Wireguard
      interfaces = {
        wg0 = {
          allowedTCPPorts = [ 993 ];
        };
      };
    };
    hostName = "nixos-laptop";
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # https://discourse.nixos.org/t/how-to-disable-networkmanager-wait-online-service-in-the-configuration-file/19963
  systemd.services.NetworkManager-wait-online.enable = false;

  home-manager.users.${username} = { };
}
