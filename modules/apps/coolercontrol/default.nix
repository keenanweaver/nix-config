{
  lib,
  config,
  username,
  pkgs,
  ...
}:
let
  cfg = config.coolercontrol;
in
{
  options = {
    coolercontrol = {
      enable = lib.mkEnableOption "Enable coolercontrol in NixOS";
      desktopEntry = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };
  config = lib.mkIf cfg.enable {

    # Allow for overclocking
    boot.kernelParams = [ "amdgpu.ppfeaturemask=0xffffffff" ];

    environment.systemPackages = with pkgs; [ liquidctl ];

    programs = {
      coolercontrol = {
        enable = true;
      };
    };

    home-manager.users.${username} = { };
  };
}
