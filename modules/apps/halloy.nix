{
  flake.modules.homeManager.halloy = {
    programs.halloy = {
      enable = true;
      settings = {
        buffer.channel.topic = {
          enabled = true;
        };
        notifications = {
          direct_message = {
            show_content = true;
            show_toast = true;
          };
          highlight = {
            show_content = true;
            show_toast = true;
          };
        };
        pane = {
          restore_on_launch = true;
        };
        servers.liberachat = {
          channels = [
            "#coffeecafe"
          ];
          nick_password_file = "/run/user/1000/secrets/libera_pass";
          nickname = "KeenanW";
          server = "irc.libera.chat";
        };
        tooltips = true;
      };
    };
  };
}
