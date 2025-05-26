{
  lib,
  config,
  username,
  vars,
  ...
}:
let
  cfg = config.rclone;
in
{
  options = {
    rclone = {
      enable = lib.mkEnableOption "Enable rclone in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} =
      { config, ... }:
      {
        programs.rclone = {
          enable = true;
          remotes = {
            myrient = {
              config = {
                type = "http";
                url = "https://myrient.erista.me";
              };
              mounts = lib.mkIf vars.gaming {
                "files" = {
                  enable = true;
                  mountPoint = "${config.home.homeDirectory}/Games/myrient";
                  options = {
                    buffer-size = "64M";
                    transfers = 16;
                    no-modtime = true;
                    no-checksum = true;
                    vfs-read-ahead = "16M";
                    vfs-fast-fingerprint = true;
                  };
                };
              };
            };
          };
        };
      };
  };
}
