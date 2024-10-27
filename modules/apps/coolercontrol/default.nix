{
  lib,
  config,
  username,
  vars,
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

    programs = {
      coolercontrol = {
        enable = true;
        nvidiaSupport = vars.nvidia;
      };
    };

    home-manager.users.${username} = { };
  };
}
