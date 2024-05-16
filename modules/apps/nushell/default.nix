{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.nushell;
in
{
  options = {
    nushell = {
      enable = lib.mkEnableOption "Enable nushell in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.nushell = {
        enable = true;
      };
    };
  };
}
