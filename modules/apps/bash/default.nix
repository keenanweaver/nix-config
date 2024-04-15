{ inputs, home-manager, lib, config, username, ... }: with lib;
let
  cfg = config.bash;
in
{
  options = {
    bash = {
      enable = mkEnableOption "Enable bash in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    programs.bash = {
      blesh.enable = true;
    };
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
      programs.bash = {
        enable = true;
        historyFile = "${config.xdg.dataHome}/bash/.bash_history";
        initExtra = ''
          function cdd {
            builtin cd "$@" && ls
          }
        '';
      };
    };
  };
}
