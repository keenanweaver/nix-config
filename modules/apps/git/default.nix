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
        programs.delta = {
          enable = true;
          enableGitIntegration = true;
          options = {
            light = false;
            line-numbers = true;
            navigate = true;
            side-by-side = true;
          };
        };
        programs.gh = {
          enable = true;
        };
        programs.git = {
          enable = true;
          settings = {
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
                "/mnt/crusader/Projects/Gitlab/moka-pics"
              ];
            };
            user = {
              email = "keenanweaver@protonmail.com";
              name = "${fullname}";
            };
          };
          includes = [ { path = "${config.xdg.configHome}/git/mocha.gitconfig"; } ];
          package = pkgs.gitFull;
          signing = {
            signByDefault = true;
            key = "0926B70C6A27AAE1";
          };
        };
      };
  };
}
