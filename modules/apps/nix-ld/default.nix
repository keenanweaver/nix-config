{
  lib,
  config,
  username,
  pkgs,
  ...
}:
let
  cfg = config.nix-ld;
in
{
  options = {
    nix-ld = {
      enable = lib.mkEnableOption "Enable nix-ld in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.nix-ld = {
      enable = true;
      libraries =
        with pkgs;
        (steam-run.args.multiPkgs pkgs)
        ++ (heroic.args.multiPkgs pkgs)
        ++ (lutris.args.multiPkgs pkgs)
        ++ [
          libGL
          SDL_image
          SDL_mixer
          SDL_ttf
          SDL2_image
          SDL2_mixer
          SDL2_ttf
          # Game-specific libraries
          # Project Zomboid
          xorg.libSM
        ];
    };
    home-manager.users.${username} = { };
  };
}
