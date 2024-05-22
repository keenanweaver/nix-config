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
  # https://libreddit.perennialte.ch/r/NixOS/comments/1cwbsqv/how_to_undervolt_amd_grapics_card_and_control_fan/
  # https://github.com/JManch/nixos/blob/main/modules/nixos/upstream/lact.nix
  # https://github.com/JManch/nixos/blob/main/modules/nixos/services/lact.nix
  options = {
    lact = {
      enable = lib.mkEnableOption "Enable lact in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nvtopPackages.amd
      lact
    ];

    systemd.services.lactd = {
      enable = true;
      description = "Radeon GPU monitor";
      after = [
        "syslog.target"
        "systemd-modules-load.service"
      ];

      unitConfig = {
        ConditionPathExists = "${pkgs.lact}/bin/lact";
      };

      serviceConfig = {
        User = "root";
        ExecStart = "${pkgs.lact}/bin/lact daemon";
      };

      wantedBy = [ "multi-user.target" ];
    };
  };
}
