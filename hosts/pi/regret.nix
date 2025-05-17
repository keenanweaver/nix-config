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
      systemd.user = {
        services = {
          rclone-myrient-nointro = {
            Unit = {
              Description = "Download No-Intro from Myrient";
            };
            Service = {
              Type = "oneshot";
              ExecStart =
                with pkgs;
                lib.getExe (writeShellApplication {
                  name = "rclone-myrient-nointro";
                  runtimeInputs = [
                    rclone
                  ];
                  text =
                    let
                      rcloneOpts = {
                        command = "copy";
                        source = "myrient:/files/No-Intro/";
                        destination = "/mnt/crusader/Games/Backups/Myrient/No-Intro/";
                        args = "-v --filter-from ${rcloneOpts.filter}";
                        filter = writeText "rclone-myrient-nointro-filter" ''
                          - Audio CD*/*
                          - CD-ROM*/*
                          - DVD-ROM*/*
                          - DVD-Video*/*
                          - Google*/*
                          - HD DVD*/*
                          - IBM*/*
                          - Microsoft - Xbox*/*
                          - Mobile*/*
                          - Nintendo - **Encrypted**
                          - Nintendo - Nintendo GameCube*/*
                          - Nintendo - Misc*/*
                          - Nintendo - **3DS**
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
                });
            };
          };
          rclone-myrient-redump = {
            Unit = {
              Description = "Download Redump from Myrient";
            };
            Service = {
              Type = "oneshot";
              ExecStart =
                with pkgs;
                lib.getExe (writeShellApplication {
                  name = "rclone-myrient-redump";
                  runtimeInputs = [
                    rclone
                  ];
                  text =
                    let
                      rcloneOpts = {
                        command = "copy";
                        source = "myrient:/files/Redump/";
                        destination = "/mnt/crusader/Games/Backups/Myrient/Redump/";
                        args = "-v --filter-from ${rcloneOpts.filter}";
                        filter = writeText "rclone-myrient-redump-filter" ''
                          - Apple**
                          - Arcade**
                          - Audio CD*/*
                          - BD-Video*/*
                          - DVD-Video*/*
                          - HD DVD-Video*/*
                          - IBM**
                          - Microsoft**
                          - Nintendo**
                          - Photo CD*/*
                          - Sony**
                          - Video CD*/*
                        '';
                      };
                    in
                    ''
                      rclone ${rcloneOpts.command} ${rcloneOpts.source} ${rcloneOpts.destination} ${rcloneOpts.args}
                    '';
                });
            };
          };
        };
        timers = {
          rclone-myrient-nointro = {
            Install.WantedBy = [ "multi-user.target" ];
            Timer = {
              OnCalendar = "Thu *-*-1..7 02:00:00 America/Chicago";
              Persistent = true;
            };
          };
          rclone-myrient-redump = {
            Install.WantedBy = [ "multi-user.target" ];
            Timer = {
              OnCalendar = "Tue *-*-8..15 02:00:00 America/Chicago";
              Persistent = true;
            };
          };
        };
      };
    };
}
