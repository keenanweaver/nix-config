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
  options = {
    gsr = {
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

    home-manager.users.${username} = {
      home.packages = with pkgs; [
        (writeShellApplication {
          name = "gsr-save-replay";
          runtimeInputs = [
            killall
          ];
          text = ''
            killall -SIGUSR1 gpu-screen-recorder
          '';
        })
      ];
      programs.plasma = {
        hotkeys = {
          commands = {
            "gsr-save-replay" = {
              name = "Save GSR Replay";
              key = "Meta+Ctrl+|";
              command = "gsr-save-replay";
              comment = "Save GPU Screen Recorder replay";
            };
          };
        };
      };
      # Using built-in autostart in the GUI will need manual intervention/updating as it results in hanging symlink after some time.
      systemd.user.services = {
        "gpu-screen-recorder-ui" = {
          Unit = {
            Description = "GPU Screen Recorder UI Service";
          };
          Service = {
            ExecStart = "${pkgs.gpu-screen-recorder-ui}/bin/gsr-ui launch-daemon";
            KillSignal = "SIGINT";
            Restart = "on-failure";
            RestartSec = 5;
          };
          Install = {
            WantedBy = [ "default.target" ];
          };
        };
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ timschumi ];
}
