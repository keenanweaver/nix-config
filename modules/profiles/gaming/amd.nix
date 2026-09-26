{ self, ... }:
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
            #ENABLE_LAYER_MESA_ANTI_LAG = 1;
          };
        };
      };
    nixos.amd =
      { config, ... }:
      {
        boot = {
          extraModulePackages = with config.boot.kernelPackages; [ zenergy ];
          kernelModules = [ "zenergy" ];
          kernelParams = [
            "amd_pstate=active" # https://wiki.archlinux.org/title/CPU_frequency_scaling#Autonomous_frequency_scaling
          ];
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
        home-manager.sharedModules = [ self.modules.homeManager.amd ];
        services.hardware.openrgb.motherboard = "amd";
      };
  };
}
