{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.bat;
in
{
  options = {
    bat = {
      enable = lib.mkEnableOption "Enable bat in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} =
      { pkgs, ... }:
      {
        programs.bat = {
          enable = true;
          extraPackages = with pkgs.bat-extras; [
            #batdiff
            #batgrep
            batman
            #batpipe
          ];
        };
      };
  };
}
