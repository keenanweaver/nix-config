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
    {
      pkgs,
      lib,
      osConfig,
      ...
    }:
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
                        source = "myrient:/files/No-Intro";
                        destination = "/mnt/crusader/Games/Backups/Myrient/No-Intro";
                        args = "-v --filter-from ${rcloneOpts.filter}";
                        filter = writeText "rclone-myrient-nointro-filter" ''
                          + /SNK - NeoGeo Pocket**/**
                          + /Sharp - X68000 (Flux)/**
                          + /Sega - SG-1000/**
                          + /Sega - PICO/**
                          + /Sega - Mega Drive - Genesis**/**
                          + /Sega - Master System - Mark III/**
                          + /Sega - Game Gear/**
                          + /Sega - 32X/**
                          + /Nintendo - Virtual Boy**/**
                          + /Nintendo - Super Nintendo Entertainment System**/**
                          + /Nintendo - Satellaview/**
                          + /Nintendo - Nintendo Entertainment System**/**
                          + /Nintendo - Nintendo DSi (Digital) (CDN) (Decrypted)/**
                          + /Nintendo - Nintendo DSi (Decrypted)/**
                          + /Nintendo - Nintendo DS (Download Play)/**
                          + /Nintendo - Nintendo DS (Decrypted)/**
                          + /Nintendo - Nintendo DS (Decrypted) (Private)/**
                          + /Nintendo - Nintendo 64DD/**
                          + /Nintendo - Nintendo 64 (BigEndian)**/**
                          + /Nintendo - Game Boy**/**
                          + /Nintendo - Family Computer Network System/**
                          + /Nintendo - Family Computer Disk System (QD)/**
                          + /Nintendo - Family Computer Disk System (FDS)/**
                          + /NEC - PC-98**/**
                          + /NEC - PC Engine**/**
                          + /Fujitsu - FM Towns**/**
                          + /Commodore - Commodore 64**/**
                          + /Commodore - Amiga**/**
                          + /Atari - Lynx**/**
                          + /Atari - Jaguar**/**
                          + /Atari - 7800**/**
                          + /Atari - 5200/**
                          + /Atari - 2600/**
                          - /*
                          - **
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
                        source = "myrient:/files/Redump";
                        destination = "/mnt/crusader/Games/Backups/Myrient/Redump";
                        args = "-v --filter-from ${rcloneOpts.filter}";
                        filter = writeText "rclone-myrient-redump-filter" ''
                          - /Sony - PlayStation/*{${rcloneOpts.regionFilter}}*
                          + /Sony - PlayStation/*{Japan,USA}*
                          - /Sony - PlayStation 2/*{${rcloneOpts.regionFilter}}*
                          + /Sony - PlayStation 2/*{Japan,USA}*
                          + /Sony - PlayStation 2 - BIOS Images/**
                          + /Sony - PlayStation - BIOS Images/**
                          - /SNK - Neo Geo CD/*{${rcloneOpts.regionFilter}}*
                          + /SNK - Neo Geo CD/**
                          + /Sharp - X68000/**
                          - /Sega - Saturn/*{${rcloneOpts.regionFilter}}*
                          + /Sega - Saturn/*{Japan,USA}*
                          - /Sega - Mega CD & Sega CD/*{${rcloneOpts.regionFilter}}*
                          + /Sega - Mega CD & Sega CD/*{Japan,USA}*
                          - /Sega - Dreamcast**/*{${rcloneOpts.regionFilter}}*
                          + /Sega - Dreamcast**/*{Japan,USA}*
                          - /Panasonic - 3DO Interactive Multiplayer/*{${rcloneOpts.regionFilter}}*
                          + /Panasonic - 3DO Interactive Multiplayer/*{Japan,USA}*
                          + /NEC - PC**/**
                          + /Microsoft - Xbox - BIOS Images/**
                          + /Atari - Jaguar CD Interactive Multimedia System/**
                          - /*
                          - **
                        '';
                        regionFilter = "Australia,Brazil,Europe,France,Germany,Italy,Korea,Netherlands,Spain,Sweden,Beta,Demo,Proto";
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
              OnCalendar = "Thu *-*-1..7 02:00:00 ${osConfig.time.timeZone}";
              Persistent = true;
            };
          };
          rclone-myrient-redump = {
            Install.WantedBy = [ "multi-user.target" ];
            Timer = {
              OnCalendar = "Tue *-*-8..15 02:00:00 ${osConfig.time.timeZone}";
              Persistent = true;
            };
          };
        };
      };
    };
}
