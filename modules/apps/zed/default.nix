{
  lib,
  config,
  username,
  pkgs,
  ...
}:
let
  cfg = config.zed;
in
{
  options = {
    zed = {
      enable = lib.mkEnableOption "Enable zed in home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.zed-editor = {
        enable = true;
        package = pkgs.zed-editor_git;
        extensions = [
          "csv"
          "cue"
          "docker-compose"
          "dockerfile"
          "ini"
          "just"
          "make"
          "nix"
          "nginx"
          "nu"
        ];
        userKeymaps = {

        };
        userSettings = ''
          {
            "features": {
              "inline_completions": false
            },
            "telemetry": {
              "metrics": false
            },
            "vim_mode": false,
            "ui_font_size": 16,
            "buffer_font_size": 16
          }
        '';
      };
    };
  };
}
