{ inputs, home-manager, lib, config, username,  ... }: with lib;
let
  cfg = config.atuin;
in
{
  options = {
    atuin = {
      enable = mkEnableOption "Enable atuin in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
      programs.atuin = {
        enable = true;
        settings = {
          history_filter = [
            "^btop$"
            "^distrobox enter bazzite-arch-exodos$"
            "^distrobox enter bazzite-arch-sys$"
            "^distrobox enter bazzite-arch-gaming$"
            "^bash$"
            "^cd$"
            "^clear$"
            "^exit$"
            "^fastfetch$"
            "^nccm$"
            "^kmon$"
            "^l$"
            "^ll$"
            "^pwd$"
            "^up$"
            "^nor$"
          ];
        };
      };
    };
  };
}
