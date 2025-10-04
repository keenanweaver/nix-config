{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  cfg = config.gsr;
  package = cfg.package.override {
    inherit (config.security) wrapperDir;
  };
in
{
  options.gsr = {
    enable = lib.mkEnableOption "Enable 'gpu-screen-recorder' with setcap wrappers for promptless recording";
    package = lib.mkPackageOption pkgs "gpu-screen-recorder" { };
    ui = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable;
        description = "Enable 'gpu-screen-recorder-ui' with setcap wrappers for global hotkeys";
      };
      package = lib.mkPackageOption pkgs "gpu-screen-recorder-ui" { };
      saveHotkey = lib.mkOption {
        type = lib.types.str;
        default = "Meta+Alt+]";
        description = "Keyboard shortcut for saving GPU Screen Recorder replay";
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      environment.systemPackages = [ cfg.package ];

      security.wrappers.gsr-kms-server = {
        owner = "root";
        group = "root";
        capabilities = "cap_sys_admin+ep";
        source = lib.getExe' package "gsr-kms-server";
      };
    })

    (lib.mkIf cfg.ui.enable {
      environment.systemPackages = [ cfg.ui.package ];

      security.wrappers.gsr-global-hotkeys = {
        owner = "root";
        group = "root";
        capabilities = "cap_setuid+ep";
        source = lib.getExe' cfg.ui.package "gsr-global-hotkeys";
      };

      home-manager.users.${username} = {
        home.packages = with pkgs; [
          (writeShellApplication {
            name = "gsr-save-replay";
            runtimeInputs = [ killall ];
            text = ''
              killall -SIGUSR1 gpu-screen-recorder
            '';
          })
        ];

        programs.plasma.hotkeys.commands.gsr-save-replay = {
          name = "Save GSR Replay";
          key = cfg.ui.saveHotkey;
          command = "gsr-save-replay";
          comment = "Save GPU Screen Recorder replay";
        };

        # Using built-in autostart in the GUI will need manual intervention/updating
        # as it results in hanging symlink after some time.
        systemd.user.services.gpu-screen-recorder-ui = {
          Unit.Description = "GPU Screen Recorder UI Service";
          Service = {
            ExecStart = "${lib.getExe' cfg.ui.package "gsr-ui"} launch-daemon";
            KillSignal = "SIGINT";
            Restart = "on-failure";
            RestartSec = 5;
          };
          Install.WantedBy = [ "default.target" ];
        };
      };
    })
  ];

  meta.maintainers = with lib.maintainers; [ keenanweaver ];
}
