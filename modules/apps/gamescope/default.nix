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
      package = pkgs.gamescope_git;
      capSysNice = false; # 'true' breaks gamescope for Steam https://github.com/NixOS/nixpkgs/issues/292620#issuecomment-2143529075
    };
    # Workaround for above https://github.com/NixOS/nixpkgs/issues/351516#issuecomment-2607156591
    services.ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-cpp;
      extraRules = [
        {
          "name" = "gamescope";
          "nice" = -20;
        }
      ];
    };

    home-manager.users.${username} = { };
  };
}
