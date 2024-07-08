{ lib, username, ... }:
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
    ]; # "v4l2loopback"
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

  programs.auto-cpufreq.enable = true;

  services = {
    udev = {
      extraRules = ''
        # https://reddit.com/r/linux_gaming/comments/196tz6v/psa_amdgpu_power_management_may_fix_your/khxs3q3/?context=3 https://gitlab.freedesktop.org/drm/amd/-/issues/1500#note_825883
        KERNEL=="card0", SUBSYSTEM=="drm", DRIVERS=="amdgpu", ATTR{device/power_dpm_force_performance_level}="manual", ATTR{device/pp_power_profile_mode}="1"
      '';
    };
  };

  # https://discourse.nixos.org/t/how-to-disable-networkmanager-wait-online-service-in-the-configuration-file/19963
  systemd.services.NetworkManager-wait-online.enable = false;

  home-manager.users.${username} =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ bottles ];
    };
}
