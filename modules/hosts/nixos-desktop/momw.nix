{
  configurations.nixos.nixos-desktop.module =
    { config, ... }:
    {
      home-manager.users.${config.my.user} =
        {
          inputs,
          lib,
          config,
          pkgs,
          ...
        }:
        {
          home.packages = with pkgs; [
            (writeShellApplication {
              name = "momw-update";
              runtimeEnv.MODLIST = "i-heart-vanilla-directors-cut";
              runtimeInputs = [
                inputs.openmw-nix.packages.${stdenv.hostPlatform.system}.momw-configurator
                inputs.openmw-nix.packages.${stdenv.hostPlatform.system}.openmw-validator
                inputs.openmw-nix.packages.${stdenv.hostPlatform.system}.umo
                tes3cmd
              ];
              text = ''
                umo sync "$MODLIST"
                umo install "$MODLIST"
                momw-configurator config "$MODLIST" --run-navmeshtool --run-validator
                umo vacuum
              '';
            })
            inputs.openmw-nix.packages.${system}.openmw-validator
            openmw
          ];
          sops = {
            secrets.nexus_pat = { };
            templates."umomwd-config.json" =
              let
                staticConfig = {
                  BASEPATH = "${config.home.homeDirectory}/Games/openmw";
                  CACHE_DIR = "${config.xdg.cacheHome}/umomwd";
                  TES3CMD = lib.getExe pkgs.tes3cmd;
                };
              in
              {
                content = builtins.toJSON (
                  staticConfig
                  // {
                    NEXUS_API_KEY = config.sops.placeholder.nexus_pat;
                  }
                );
                mode = "0600";
                path = "${config.xdg.configHome}/umomwd/config.json";
              };
          };
        };
    };
  flake-file.inputs.openmw-nix = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "git+https://codeberg.org/PopeRigby/openmw-nix.git";
  };
}
