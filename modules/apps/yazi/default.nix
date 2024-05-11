{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.yazi;
in
{
  options = {
    yazi = {
      enable = lib.mkEnableOption "Enable yazi in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.yazi = {
        enable = true;
        enableBashIntegration = true;
        enableNushellIntegration = true;
        enableZshIntegration = true;
        settings = {
          manager = {
            linemode = "mtime";
            show_hidden = true;
            show_symlink = true;
            sort_by = "natural";
            sort_dir_first = true;
            sort_reverse = false;
            sort_sensitive = false;
          };
        };
      };
    };
  };
}
