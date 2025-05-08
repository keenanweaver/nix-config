{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.television;
in
{
  options = {
    television = {
      enable = lib.mkEnableOption "Enable television in home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.television = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        settings = {
          tick_rate = 50;
          ui = {
            use_nerd_font_icons = true;
            ui_scale = 120;
            show_preview_panel = true;
          };
          keybindings = {
            quit = [
              "esc"
              "ctrl-c"
            ];
          };
        };
      };
    };
  };
}
