{ inputs, home-manager, lib, config, username,  ... }: with lib;
let
  cfg = config.fzf;
in
{
  options = {
    fzf = {
      enable = mkEnableOption "Enable fzf in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
      programs.fzf = {
        enable = true;
        defaultCommand = "fd --type f";
        fileWidgetOptions = [
          "--preview bat -pp --color=always {}"
        ];
      };
    };
  };
}
