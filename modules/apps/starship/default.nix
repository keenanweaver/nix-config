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
          add_newline = true;
          character = {
            success_symbol = "[⮞](bold lavender)";
            error_symbol = "[⮞](bold red)";
          };
          cmd_duration = {
            min_time = 1000;
            format = "[$duration ](fg:yellow)";
          };
          directory = {
            truncation_symbol = ".../";
          };
          format = lib.concatStrings [
            "[╭╴$symbol](lavender)$os$shell\n"
            "[├](lavender)$all"
            "[╰$symbol](lavender)$character"
          ];
          os = {
            disabled = false;
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
