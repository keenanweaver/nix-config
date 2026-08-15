{
  flake.modules = {
    homeManager.gaming-profile =
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

    nixos.gaming-profile =
      {
        inputs,
        lib,
        config,
        pkgs,
        ...
      }:
      {
        imports = [
          inputs.lsfg-vk-flake.nixosModules.default
        ];

        chaotic.mesa-git.extraPackages = lib.mkIf config.chaotic.mesa-git.enable [
          pkgs.lsfg-vk
        ];

        services.lsfg-vk = {
          enable = true;
          ui.enable = true;
        };
      };
  };

  flake-file.inputs.lsfg-vk-flake = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:pabloaul/lsfg-vk-flake/main";
  };
}
