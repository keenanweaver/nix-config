{
  flake.modules.homeManager.desktop-profile =
    { config, ... }:
    {
      programs.ghostty = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;

        settings = {
          background-opacity = 0.7;
          confirm-close-surface = true;
          copy-on-select = "clipboard";
          cursor-style = "block_hollow";
          cursor-style-blink = false;
          font-family = config.programs.plasma.fonts.fixedWidth.family;
          font-size = config.programs.plasma.fonts.fixedWidth.pointSize;
          maximize = true;
          mouse-hide-while-typing = true;
          scrollback-limit = 10000;
          window-decoration = "server";
          window-save-state = "always";
        };
      };
    };
}
