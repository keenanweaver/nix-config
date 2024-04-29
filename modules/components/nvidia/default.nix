{ lib, config, username, pkgs, ... }:
let
  cfg = config.nvidia;
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in
{
  options = {
    nvidia = {
      enable = lib.mkEnableOption "Enable nvidia in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    boot.blacklistedKernelModules = [ "nouveau" ];
    environment.systemPackages = [ nvidia-offload ];
    hardware = {
      nvidia = {
        modesetting.enable = true;
        nvidiaPersistenced = true;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;
      };
    };
    services.xserver.videoDrivers = lib.mkForce [ "nvidia" ];
    home-manager.users.${username} = { };
  };
}
