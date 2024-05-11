{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.lsd;
in
{
  options = {
    lsd = {
      enable = lib.mkEnableOption "Enable lsd in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.lsd = {
        enable = true;
        settings = {
          color = {
            when = "always";
          };
          icons = {
            when = "always";
            theme = "fancy";
            separator = "  ";
          };
          layout = "oneline";
          size = "short";
          permission = "rwx";
          hyperlink = "never";
          no-symlink = false;
          symlink-arrow = "⇒";
        };
      };
    };
  };
}
