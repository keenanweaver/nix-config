{
  flake.modules.homeManager.halloy =
    { config, ... }:
    {
      programs.halloy = {
        enable = true;
        settings = {
          buffer.channel.topic.enabled = true;
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
          pane.restore_on_launch = true;
          servers.liberachat = {
            channels = [
              "#coffeecafe"
            ];
            nick_password_file = config.sops.secrets.libera_pass.path;
            nickname = "KeenanW";
            server = "irc.libera.chat";
          };
          tooltips = true;
        };
      };
      sops.secrets."libera_pass" = { };
    };
}
