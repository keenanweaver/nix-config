{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.halloy;
in
{
  options = {
    halloy = {
      enable = lib.mkEnableOption "Enable halloy in home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.halloy = {
        enable = true;
        settings = {
          buffer.channel.topic = {
            enabled = true;
          };
          notifications = {
            direct_message = {
              show_toast = true;
              show_content = true;
            };
            highlight = {
              show_toast = true;
              show_content = true;
            };
          };
          pane = {
            restore_on_launch = true;
          };
          servers.liberachat = {
            channels = [
              "#coffeecafe"
            ];
            nickname = "KeenanW";
            nick_password_file = "/run/user/1000/secrets/libera_pass";
            server = "irc.libera.chat";
          };
          tooltips = true;
        };
      };
    };
  };
}
