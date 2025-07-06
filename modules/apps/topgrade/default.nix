{
  lib,
  config,
  username,
  vars,
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
      { pkgs, ... }:
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
                "nix"
                "vim"
                "system"
              ];
              ignore_failures = [ "powershell" ];
              no_retry = true;
              notify_each_step = true;
            };
            pre_commands = {
              "NixOS Rebuild" = "${pkgs.nh}/bin/nh os switch --update";
            };
            commands = { };
            post_commands =
              { }
              // lib.optionalAttrs vars.gaming {
                #"SteamTinkerLaunch configure" = "script-stl-configure";
              };
          };
        };
      };
  };
}
