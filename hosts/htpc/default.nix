{
  lib,
  username,
  pkgs,
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
    ../../modules/desktop-environments/kde/plasma-manager/desktop.nix
  ];

  # Custom modules
  desktop.enable = true;
  gaming.enable = true;

  boot = {
    initrd = {
      availableKernelModules = lib.mkDefault [
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "usbhid"
        "sd_mod"
        "sr_mod"
      ];
    };
    kernelModules = lib.mkDefault [
      "dm-snapshot"
      "kvm-amd"
      "tcp_bbr"
      "uinput"
    ];
    kernelPackages = lib.mkForce pkgs.linuxPackages_cachyos;
    kernelParams = lib.mkDefault [
      "amd_iommu=on"
      "amd_pstate=guided"
      "microcode.amd_sha_check=off"
    ];
    tmp.tmpfsSize = "100%";
  };

  hardware = {
    amdgpu = {
      initrd.enable = true;
      overdrive = {
        enable = true;
        ppfeaturemask = "0xffffffff";
      };
    };
    cpu.amd.updateMicrocode = true;
  };

  jovian = {
    decky-loader = {
      enable = true;
    };
    hardware = {
      has.amd.gpu = true;
    };
    steam = {
      autoStart = true;
      enable = true;
    };
  };

  networking = {
    hostName = "nixos-htpc";
  };

  nix = {
    settings = {
      extra-trusted-public-keys = [
        "jovian-nixos.cachix.org-1:mAWLjAxLNlfxAnozUjOqGj4AxQwCl7MXwOfu7msVlAo="
      ];
      extra-trusted-substituters = [
        "https://jovian-nixos.cachix.or"
      ];
    };
  };

  zramSwap = {
    enable = true;
  };

  home-manager.users.${username} = { };
}
