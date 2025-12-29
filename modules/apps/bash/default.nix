{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.bash;
in
{
  options = {
    bash = {
      enable = lib.mkEnableOption "Enable bash in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.bash = {
      blesh.enable = true;
    };
    home-manager.users.${username} =
      { config, pkgs, ... }:
      {
        programs.bash = {
          enable = true;
          historyFile = "${config.xdg.dataHome}/bash/.bash_history";
          initExtra = ''
            cd() {
              builtin cd "$@" && ${lib.getExe pkgs.lsd} -la
            }
          '';
        };
      };
  };
}
