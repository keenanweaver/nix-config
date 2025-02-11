{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.starship;
in
{
  options = {
    starship = {
      enable = lib.mkEnableOption "Enable starship in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.starship = {
        enable = true;
        enableBashIntegration = true;
        enableNushellIntegration = true;
        enableZshIntegration = true;
        settings = {
          add_newline = false;
          character = {
            success_symbol = "[›](bold green)";
            error_symbol = "[›](bold red)";
          };
          cmd_duration = {
            min_time = 1000;
            format = "[$duration ](fg:yellow)";
          };
          format = "
[┌───────────────────>](bold green)
[│](bold green)$all
[└─>](bold green)";
          os = {
            disabled = false;
            format = "$symbol";
          };
          shell = {
            disabled = false;
          };
          status = {
            disabled = false;
          };
          username = {
            disabled = false;
            show_always = true;
            style_root = "red bold";
          };
        };
      };
    };
  };
}
