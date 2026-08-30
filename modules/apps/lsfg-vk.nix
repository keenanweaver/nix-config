{
  flake.modules = {
    homeManager.profile-gaming =
      { config, ... }:
      {
        services.flatpak = {
          overrides.global = {
            Context.filesystems = [
              "xdg-config/lsfg-vk:rw"
            ];
            Environment.LSFG_CONFIG = "${config.xdg.configHome}/lsfg-vk/conf.toml";
          };
          packages = [
            "org.freedesktop.Platform.VulkanLayer.lsfgvk/x86_64/24.08"
            "org.freedesktop.Platform.VulkanLayer.lsfgvk/x86_64/25.08"
          ];
        };
      };
    nixos.profile-gaming =
      { inputs, pkgs, ... }:
      {
        imports = [
          inputs.omniflake.flakes.lsfg-vk-flake.nixosModules.default
        ];
        chaotic.mesa-git.extraPackages = [
          pkgs.lsfg-vk
        ];
        services.lsfg-vk = {
          enable = true;
          ui.enable = true;
        };
      };
  };
}
