{
  lib,
  pkgs,
  inputs,
  modulesPath,
  ...
}:
{
  imports = [
    # System
    #./hardware-configuration.nix
    ./impermanence.nix
    # Profiles
    ../../modules
    # Raspberry Pi
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
  ];

  # Custom modules
  server.enable = true;
  # Apps
  btop.enable = lib.mkForce false;
  direnv.enable = lib.mkForce false;
  helix.enable = lib.mkForce false;
  jujutsu.enable = lib.mkForce false;
  nvim.enable = lib.mkForce false;
  virtualization.enable = lib.mkForce false;
  # System
  flatpak.enable = lib.mkForce false;

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "usbhid"
      ];
    };
    kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_rpi4;
    loader.systemd-boot.enable = lib.mkForce false;
    supportedFilesystems = lib.mkForce [
      "vfat"
      "btrfs"
      "tmpfs"
    ];
  };

}
