{
  username,
  ...
}:
{
  imports = [
    ./pi.nix
  ];

  networking = {
    hostName = "regretpi";
    interfaces.end0 = {
      ipv4.addresses = [
        {
          address = "10.20.20.31";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = {
      address = "10.20.20.1";
      interface = "end0";
    };
    nameservers = [ "10.20.20.1" ];
  };

  home-manager.users.${username} =
    { pkgs, lib, ... }:
    {
      systemd.user.services = {
        rclone-myrient-nointro = {
          Unit = {
            Description = "Download No-Intro from Myrient";
          };
          Service = {
            Type = "oneshot";
            ExecStart = lib.getExe (
              pkgs.writeShellApplication {
                name = "rclone-myrient-nointro";
                runtimeInputs = with pkgs; [
                  rclone
                ];
                text =
                  let
                    rcloneOpts = {
                      command = "copy";
                      source = "myrient:/files/No-Intro/";
                      destination = "/mnt/crusader/Games/Backups/Myrient/No-Intro/";
                      args = "-vv --filter-from ${rcloneOpts.filter}";
                      filter = pkgs.writeText "rclone-myrient-nointro-filter" ''
                        - Audio CD*/*
                        - CD-ROM*/*
                        - DVD-ROM*/*
                        - DVD-Video*/*
                        - Google*/*
                        - HD DVD*/*
                        - IBM*/*
                        - Microsoft - Xbox*/*
                        - Mobile*/*
                        - Nintendo - Misc*/*
                        - Nintendo - New*/*
                        - Nintendo - Nintendo 3DS*/*
                        - Nintendo - SDKs*/*
                        - Nintendo - Wallpapers*/*
                        - Nintendo - Wii*/*
                        - Nintendo - amiibo*/*
                        - Non-Redump*/*
                        - Ouya*/*
                        - Sony*/*
                        - Source Code*/*
                        - Unofficial*/*
                        - Various*/*
                        - Video CD*/*
                        - Web*/*
                      '';
                    };
                  in
                  ''
                    rclone ${rcloneOpts.command} ${rcloneOpts.source} ${rcloneOpts.destination} ${rcloneOpts.args}
                  '';
              }
            );
          };
        };
      };
    };
}
