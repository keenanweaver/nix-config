{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.foot;
in
{
  options = {
    foot = {
      enable = lib.mkEnableOption "Enable foot in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.foot = {
        enable = true;
        server.enable = true;
        settings = {
          cursor = {
            blink = "yes";
            blink-rate = 1500;
          };
          main = {
            dpi-aware = "yes";
            pad = "10x10";
          };
          mouse = {
            hide-when-typing = "yes";
          };
          key-bindings = {
            clipboard-copy = "Control+Shift+c";
            clipboard-paste = "Control+Shift+v";
            primary-paste = "Shift+Insert";
          };
        };
      };
    };
  };
}
