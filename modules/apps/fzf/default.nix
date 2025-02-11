{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.fzf;
in
{
  options = {
    fzf = {
      enable = lib.mkEnableOption "Enable fzf in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.fzf = {
        enable = true;
        defaultCommand = "fd --type f";
        enableBashIntegration = true;
        enableZshIntegration = true;
        fileWidgetOptions = [ "--preview bat -pp --color=always {}" ];
      };
    };
  };
}
