{ lib, config, username, ... }:
let
  cfg = config.alacritty;
in
{
  options = {
    alacritty = {
      enable = lib.mkEnableOption "Enable alacritty in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.alacritty = {
        enable = true;
        settings = {
          cursor = {
            style = "Block";
            unfocused_hollow = true;
          };
          keyboard.bindings = [
            { key = "Q"; mods = "Control"; action = "Quit"; }
            { key = "O"; mods = "Control"; action = "ScrollHalfPageUp"; }
            { key = "P"; mods = "Control"; action = "ScrollHalfPageDown"; }
            { key = "Equals"; mods = "Control"; action = "IncreaseFontSize"; }
            { key = "Minus"; mods = "Control"; action = "DecreaseFontSize"; }
            { key = "Key0"; mods = "Control"; action = "ResetFontSize"; }
            { key = "N"; mods = "Control|Shift"; action = "SpawnNewInstance"; }
            { key = "C"; mods = "Control|Shift"; action = "Copy"; }
            { key = "V"; mods = "Control|Shift"; action = "Paste"; }
            #{ key = "C"; mods = "Control"; chars = \\x03; } # Cancel
          ];
          live_config_reload = true;
          mouse = {
            bindings = [{ mouse = "Middle"; action = "PasteSelection"; }];
            hide_when_typing = false;
          };
          scrolling = {
            history = 10000;
            multiplier = 3;
          };
          window = {
            dynamic_title = true;
            dimensions = {
              columns = 0;
              lines = 0;
            };
            padding.x = 5;
            padding.y = 5;
            decorations = "Full";
            startup_mode = "Maximized";
          };
        };
      };
    };
  };
}
