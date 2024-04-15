{ inputs, home-manager, lib, config, username,  ... }: with lib;
let
  cfg = config.starship;
in
{
  options = {
    starship = {
      enable = mkEnableOption "Enable starship in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
      programs.starship = {
        enable = true;
        settings =
          {
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
