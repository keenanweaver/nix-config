{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.gsr;
in
{
  options.gsr = {
    enable = lib.mkEnableOption "Enable gsr in NixOS";
    defaultAudioDevice = lib.mkOption {
      type = lib.types.str;
    };
  };
  config = lib.mkIf cfg.enable {
    programs = {
      gpu-screen-recorder = {
        enable = true;
      };
      gpu-screen-recorder-ui.enable = true;
    };

    home-manager.users.${username} =
      { pkgs, ... }:
      {
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
      };
  };
}
