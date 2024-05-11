{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.boxxy;
in
{
  options = {
    boxxy = {
      enable = lib.mkEnableOption "Enable boxxy in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} =
      { config, username, ... }:
      {
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
