{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.gsr;
  package = cfg.package.override {
    inherit (config.security) wrapperDir;
  };

  uiPackage = cfg.uiPackage.override {
    gpu-screen-recorder = package;
    inherit (config.security) wrapperDir;
  };
in
{
  options = {
    programs.gsr = {
      package = lib.mkPackageOption pkgs "gpu-screen-recorder" { };
      uiPackage = lib.mkPackageOption pkgs "gpu-screen-recorder-ui" { };
      notifPackage = lib.mkPackageOption pkgs "gpu-screen-recorder-notification" { };

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to install gpu-screen-recorder and generate setcap
          wrappers for promptless recording.
        '';
      };

      overlayUI = {
        enable = lib.mkEnableOption "the GPU Screen Recorder overlay UI";

        autoStart = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Whether to start the GPU Screen Recorder overlay UI automatically
            on login via a systemd user service.
          '';
        };
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        environment.systemPackages = [ cfg.package ];

        security.wrappers."gsr-kms-server" = {
          owner = "root";
          group = "root";
          capabilities = "cap_sys_admin+ep";
          source = lib.getExe' package "gsr-kms-server";
        };
      }

      (lib.mkIf cfg.overlayUI.enable {
        environment.systemPackages = [
          cfg.uiPackage
          cfg.notifPackage
        ];

        security.wrappers."gsr-global-hotkeys" = {
          owner = "root";
          group = "root";
          capabilities = "cap_setuid+ep";
          source = lib.getExe' uiPackage "gsr-global-hotkeys";
        };

        systemd.user.services."gpu-screen-recorder-ui" = lib.mkIf cfg.overlayUI.autoStart {
          description = "GPU Screen Recorder UI";
          wantedBy = [ "graphical-session.target" ];
          partOf = [ "graphical-session.target" ];
          serviceConfig = {
            ExecStart = "${lib.getExe' uiPackage "gsr-ui"} launch-daemon";
            Restart = "on-failure";
          };
        };
      })
    ]
  );

  meta.maintainers = with lib.maintainers; [
    timschumi
    AhmedAmr
  ];
}
