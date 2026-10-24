{ self, inputs, ... }:
{
  flake.modules = {
    homeManager.amd =
      { pkgs, ... }:
      {
        home = {
          packages = with pkgs; [
            amdgpu_top
            nvtopPackages.amd
          ];
          sessionVariables = {
            # https://wiki.cachyos.org/configuration/gaming/#increase-maximum-shader-cache-size
            AMD_VULKAN_ICD = "RADV";
            MESA_SHADER_CACHE_MAX_SIZE = "16G";
          };
        };
      };
    nixos.amd =
      { config, ... }:
      {
        imports = [ inputs.ucodenix.nixosModules.default ];
        boot = {
          extraModulePackages = with config.boot.kernelPackages; [ zenergy ];
          kernelModules = [ "zenergy" ];
          kernelParams = [
            "amd_pstate=active" # https://wiki.archlinux.org/title/CPU_frequency_scaling#Autonomous_frequency_scaling
            "microcode.amd_sha_check=off"
          ];
        };
        hardware.amdgpu = {
          #initrd.enable = true;
          overdrive.enable = true;
        };
        home-manager.sharedModules = [ self.modules.homeManager.amd ];
        services.ucodenix.enable = true;
      };
  };
  flake-file.inputs.ucodenix.url = "github:e-tho/ucodenix";
}
