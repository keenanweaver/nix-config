{ self, ... }:
let
  mono = self.lib.fonts.monospace;
in
{
  flake.modules.homeManager.profile-desktop = _: {
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
        font-family = mono.family;
        font-size = mono.size;
        maximize = true;
        mouse-hide-while-typing = true;
        scrollback-limit = 10000;
        window-decoration = "server";
        window-save-state = "always";
      };
    };
  };
}
