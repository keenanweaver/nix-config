{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.topgrade;
in
{
  options = {
    topgrade = {
      enable = lib.mkEnableOption "Enable topgrade in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} =
      {
        config,
        pkgs,
        ...
      }:
      {
        programs.topgrade = {
          enable = true;
          settings = {
            containers = {
              runtime = "podman";
            };
            linux = {
              "arch_package_manager" = "paru";
            };
            misc = {
              "display_time" = true;
              disable = [
                "clam_av_db"
                "helix"
                "home_manager"
                "vim"
                "system"
              ];
            };
            pre_commands = {
              "Delete conflicting HM files" = "${pkgs.coreutils}/bin/rm --force ${config.xdg.configHome}/gtk-2.0/gtkrc ${config.xdg.configHome}/mimeapps.list";
              "NixOS Rebuild" = "${pkgs.nh}/bin/nh os switch --update";
            };
            commands = { };
            post_commands = { };
          };
        };
      };
  };
}
