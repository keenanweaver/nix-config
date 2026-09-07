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
        chaotic.mesa-git.extraPackages =
          with inputs.omniflake.flakes.lsfg-vk-nix-nyramu.packages.${pkgs.stdenv.hostPlatform.system}; [
            lsfg-vk
          ];
        environment.systemPackages =
          with inputs.omniflake.flakes.lsfg-vk-nix-nyramu.packages.${pkgs.stdenv.hostPlatform.system}; [
            lsfg-vk
            lsfg-vk-ui
          ];
      };
  };
}
