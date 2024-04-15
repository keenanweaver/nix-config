{ inputs, home-manager, lib, config, pkgs, username, fullname, ... }: with lib;
let
  cfg = config.git;
in
{
  options = {
    git = {
      enable = mkEnableOption "Enable git in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      package = pkgs.gitFull;
    };
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
      programs.git = with pkgs; {
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
              "/mnt/crusader/Projects/Gitlab/moka-pics"
              "/mnt/crusader/Projects/GitHub/nix-config"
            ];
          };
        };
        includes = [{ path = "${config.xdg.configHome}/git/mocha.gitconfig"; }];
        package = gitFull;
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
