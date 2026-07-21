{
  flake.modules.nixos.gaming-profile =
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

      uiPackage = cfg.ui.package.override {
        inherit (config.security) wrapperDir;
        gpu-screen-recorder = package;
      };
    in
    {
      options = {
        programs.gsr = {
          enable = lib.mkOption {
            default = false;
            description = ''
              Whether to install gpu-screen-recorder and generate setcap
              wrappers for promptless recording.
            '';
            type = lib.types.bool;
          };
          package = lib.mkPackageOption pkgs [ "local" "gpu-screen-recorder" ] { };
          ui = {
            enable = lib.mkEnableOption "the GPU Screen Recorder overlay UI";
            package = lib.mkPackageOption pkgs [ "local" "gpu-screen-recorder-ui" ] { };
            notifPackage = lib.mkPackageOption pkgs [ "local" "gpu-screen-recorder-notification" ] { };
          };
        };
      };
      config = lib.mkIf cfg.enable (
        lib.mkMerge [
          {
            environment.systemPackages = [ cfg.package ];

            security.wrappers."gsr-kms-server" = {
              capabilities = "cap_sys_admin+ep";
              group = "root";
              owner = "root";
              source = lib.getExe' package "gsr-kms-server";
            };
          }

          (lib.mkIf cfg.ui.enable {
            environment.systemPackages = [
              cfg.ui.package
              cfg.ui.notifPackage
            ];

            security.wrappers."gsr-global-hotkeys" = {
              capabilities = "cap_setuid+ep";
              group = "root";
              owner = "root";
              source = lib.getExe' uiPackage "gsr-global-hotkeys";
            };
          })
        ]
      );
    };
}
