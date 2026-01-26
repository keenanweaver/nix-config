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
  catppuccinTheming.enable = true;
  dms.enable = true;
  kde.enable = true;
  niri.enable = true;

  boot = {
    extraModprobeConfig = ''
      options cf680211 ieee80211_regdom="US"
    '';
    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "usb_storage"
      "usbhid"
      "sd_mod"
    ];
    kernelModules = [
      "tcp_bbr"
      "kvm-amd"
    ];
    kernelParams = [
      "amd_iommu=on"
      "amd_pstate=guided"
    ];
    loader = {
      limine.style.interface.resolution = "1920x1080";
    };
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

  nix.settings.build-dir = "/nix/build";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # https://discourse.nixos.org/t/how-to-disable-networkmanager-wait-online-service-in-the-configuration-file/19963
  systemd.services.NetworkManager-wait-online.wantedBy = lib.mkForce [ ];

  home-manager.users.${username} = { };
}
