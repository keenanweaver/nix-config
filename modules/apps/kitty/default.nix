{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.kitty;
in
{
  options = {
    kitty = {
      enable = lib.mkEnableOption "Enable kitty in home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.kitty = {
        enable = true;
        keybindings = {
          "ctrl+c" = "copy_or_interrupt";
        };
        settings = {
          scrollback_lines = 10000;
          enable_audio_bell = false;
          update_check_interval = 0;
        };
      };
    };
  };
}
