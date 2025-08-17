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
in
{
  options = {
    programs.gsr = {
      package = lib.mkPackageOption pkgs "gpu-screen-recorder" { };
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to install gpu-screen-recorder and generate setcap
          wrappers for promptless recording.
        '';
      };
      ui = {
        package = lib.mkPackageOption pkgs "gpu-screen-recorder-ui" { };
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Whether to install gpu-screen-recorder-ui and generate setcap
            wrappers for global hotkeys.
          '';
        };
      };
      defaultAudioDevice = lib.mkOption {
        type = lib.types.str;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
      cfg.ui.package
    ];
    security.wrappers = {
      "gsr-global-hotkeys" = {
        owner = "root";
        group = "root";
        capabilities = "cap_setuid+ep";
        source = lib.getExe' cfg.ui.package "gsr-global-hotkeys";
      };
      "gsr-kms-server" = {
        owner = "root";
        group = "root";
        capabilities = "cap_sys_admin+ep";
        source = lib.getExe' package "gsr-kms-server";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ timschumi ];
}
