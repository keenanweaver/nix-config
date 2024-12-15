{
  lib,
  config,
  username,
  pkgs,
  ...
}:
let
  cfg = config.gamescope;
in
{
  options = {
    gamescope = {
      enable = lib.mkEnableOption "Enable gamescope in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.gamescope = {
      enable = true;
      package = pkgs.gamescope_git; # Chaotic package
      capSysNice = true; # 'true' breaks gamescope for Steam https://github.com/NixOS/nixpkgs/issues/292620#issuecomment-2143529075
    };
    home-manager.users.${username} = { };
  };
}
