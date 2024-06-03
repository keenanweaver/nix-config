{
  lib,
  config,
  pkgs,
  username,
  fullname,
  ...
}:
let
  cfg = config.git;
in
{
  options = {
    git = {
      enable = lib.mkEnableOption "Enable git in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      package = pkgs.gitFull;
    };
    home-manager.users.${username} =
      { config, pkgs, ... }:
      {
        programs.git = {
          enable = true;
          delta = {
            enable = true;
            options = {
              light = false;
              line-numbers = true;
              navigate = true;
              side-by-side = true;
            };
          };
          extraConfig = {
            diff = {
              colorMoved = "default";
            };
            merge = {
              conflictstyle = "diff3";
            };
            safe = {
              directory = [
                "/mnt/crusader/Projects/Codeberg/nix-config"
                "/mnt/crusader/Projects/GitHub/keenanweaver.github.io"
                "/mnt/crusader/Projects/GitHub/nix-config"
                "/mnt/crusader/Projects/GitHub/nix-config/.git"
                "/mnt/crusader/Projects/Gitlab/moka-pics"
              ];
            };
          };
          includes = [ { path = "${config.xdg.configHome}/git/mocha.gitconfig"; } ];
          package = pkgs.gitFull;
          userName = "${fullname}";
          userEmail = "keenanweaver@protonmail.com";
          signing = {
            signByDefault = true;
            key = "0926B70C6A27AAE1";
          };
        };
      };
  };
}
