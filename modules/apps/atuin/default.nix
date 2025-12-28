{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.atuin;
in
{
  options = {
    atuin = {
      enable = lib.mkEnableOption "Enable atuin in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.atuin = {
        enable = true;
        enableBashIntegration = true;
        enableNushellIntegration = true;
        enableZshIntegration = true;
        settings = {
          history_filter = [
            "^btop$"
            "^distrobox enter bazzite-arch-exodos$"
            "^distrobox enter bazzite-arch-gaming$"
            "^bash$"
            "^cd$"
            "^exit$"
            "^fastfetch$"
            "^kmon$"
            "^l$"
            "^ll$"
            "^ls"
            "^lsd"
            "^pwd$"
            "^upd$"
            "^nor$"
            "^ngc$"
            "^rbn$"
          ];
        };
      };
    };
  };
}
