{ inputs, home-manager, lib, config, username,  ... }: with lib;
let
  cfg = config.boxxy;
in
{
  options = {
    boxxy = {
      enable = mkEnableOption "Enable boxxy in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
      programs.boxxy = {
        enable = true;
        rules = [
          {
            name = "wget";
            target = "/home/${username}/.wget-hsts";
            rewrite = "${config.xdg.dataHome}/wget-hsts";
            mode = "file";
          }
        ];
      };
    };
  };
}
