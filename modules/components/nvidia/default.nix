{ inputs, home-manager, lib, config, username, ... }: with lib;
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
      enable = mkEnableOption "Enable nvidia in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    boot.blacklistedKernelModules = [ "nouveau" ];
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
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: { };
  };
}
