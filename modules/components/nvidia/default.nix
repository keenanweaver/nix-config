{
  lib,
  config,
  username,
  pkgs,
  ...
}:
let
  cfg = config.nvidia;
in
{
  options = {
    nvidia = {
      enable = lib.mkEnableOption "Enable nvidia in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    boot.initrd.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];
    boot.blacklistedKernelModules = [ "nouveau" ];
    environment.systemPackages = with pkgs; [
      (writeShellScriptBin "nvidia-offload" ''
        export __NV_PRIME_RENDER_OFFLOAD=1
        export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
        export __VK_LAYER_NV_optimus=NVIDIA_only
        exec -a "$0" "$@"
      '')
    ];
    hardware = {
      nvidia = {
        modesetting.enable = true;
        nvidiaPersistenced = true;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;
      };
    };
    home-manager.users.${username} = { };
  };
}
