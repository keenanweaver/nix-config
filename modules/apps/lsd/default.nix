{ inputs, home-manager, lib, config, username,  ... }: with lib;
let
  cfg = config.lsd;
in
{
  options = {
    lsd = {
      enable = mkEnableOption "Enable lsd in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
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
