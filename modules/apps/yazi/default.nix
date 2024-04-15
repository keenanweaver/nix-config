{ inputs, home-manager, lib, config, username,  ... }: with lib;
let
  cfg = config.yazi;
in
{
  options = {
    yazi = {
      enable = mkEnableOption "Enable yazi in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
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
