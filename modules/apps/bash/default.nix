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
      blesh.enable = false;
    };
    home-manager.users.${username} =
      { config, ... }:
      {
        programs.bash = {
          enable = true;
          historyFile = "${config.xdg.dataHome}/bash/.bash_history";
          initExtra = ''
            cd() {
              builtin cd "$@" && lsd -la
            }
          '';
        };
      };
  };
}
