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
  gaming = {
    enable = true;
    installPackages = false;
  };
  sunshine.enable = lib.mkForce false;
  zerotier.enable = lib.mkForce false;

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

  programs = {
    _2ship2harkinian-git.enable = lib.mkForce false;
    perfect-dark-git.enable = lib.mkForce false;
    shipwright-git.enable = lib.mkForce false;
    sm64coopdx.enable = lib.mkForce false;
    spaghetti-kart-git.enable = lib.mkForce false;
    starship-sf64.enable = lib.mkForce false;
  };

  zramSwap = {
    enable = true;
  };

  home-manager.users.${username} = {
    home.packages = with pkgs; [
      moonlight-qt
      ## Emulators
      mednafen
      mednaffe
      (retroarch.withCores (
        cores: with cores; [
          beetle-psx-hw
          beetle-saturn
          blastem
          mgba
        ]
      ))
      inputs.chaotic.packages.${system}.shadps4_git
      xenia-canary
      ## Input
      joystickwake
      oversteer
      sc-controller
      ## Wine
      umu-launcher
      inputs.nix-gaming.packages.${system}.wine-tkg-ntsync
      winetricks
    ];
  };
}
