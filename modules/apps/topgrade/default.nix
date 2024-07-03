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
      { config, vars, ... }:
      {
        programs.topgrade = {
          enable = true;
          settings = {
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
              "Delete conflicting HM files" = "rm --force ${config.xdg.configHome}/gtk-2.0/gtkrc ${config.xdg.configHome}/mimeapps.list ${config.xdg.configHome}/fontconfig/conf.d/10-hm-fonts.conf";
              "NixOS Rebuild" = "nh os switch --update";
            };
            commands = { };
            post_commands =
              { }
              // lib.optionalAttrs vars.gaming {
                "Check SteamTinkerLaunch compat" = "steamtinkerlaunch compat add";
              };
          };
        };
      };
  };
}
