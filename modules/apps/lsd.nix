{
  flake.modules.homeManager.base-profile = {
    programs.lsd = {
      enable = true;
      settings = {
        color = {
          when = "always";
        };
        hyperlink = "never";
        icons = {
          separator = "  ";
          theme = "fancy";
          when = "always";
        };
        layout = "oneline";
        no-symlink = false;
        permission = "rwx";
        size = "short";
        symlink-arrow = "⇒";
      };
    };
  };
}
