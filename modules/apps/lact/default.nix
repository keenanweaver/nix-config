{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.lact;
in
{
  # https://reddit.com/r/NixOS/comments/1cwbsqv/how_to_undervolt_amd_grapics_card_and_control_fan/
  # https://github.com/JManch/nixos/blob/main/modules/nixos/upstream/lact.nix
  # https://github.com/JManch/nixos/blob/main/modules/nixos/services/lact.nix
  options = {
    lact = {
      enable = lib.mkEnableOption "Enable lact in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {

    # Allow for overclocking
    boot.kernelParams = [ "amdgpu.ppfeaturemask=0xffffffff" ];

    environment.systemPackages = with pkgs; [
      nvtopPackages.amd
      lact
    ];

    systemd.services.lact = {
      description = "AMDGPU Control Daemon";
      after = [ "multi-user.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.lact}/bin/lact daemon";
        Type = "simple";
        # Run as root since we need direct hardware access
        User = "root";
        Group = "root";
        Restart = "on-failure";
        RestartSec = "5";
      };
    };
  };
}
