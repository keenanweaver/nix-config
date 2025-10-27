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
          rclone-myrient-chd = {
            Unit = {
              Description = "Download chd packs from Myrient";
            };
            Service = {
              ExecStart =
                with pkgs;
                lib.getExe (writeShellApplication {
                  name = "rclone-myrient-chd";
                  runtimeInputs = [
                    rclone
                  ];
                  text =
                    let
                      chdDest = "/mnt/crusader/Games/Rom/CHD";
                      filter = "Asia,Austria,Australia,Belgium,Brazil,China,Croatia,Denmark,Europe,Finland,France,Germany,Greece,India,Italy,Ireland,Korea,Netherlands,Norway,Poland,Portugal,Russia,Scandinavia,'South Africa',Spain,Sweden,Switzerland,Taiwan,UK,Beta,Demo,Proto";
                    in
                    ''
                      # NEC TURBOGRAFX 16
                      rclone copy myrient:"/files/Internet Archive/chadmaster/pcecd-chd-zstd-redump/tgcd-chd-zstd/" "${chdDest}/NEC TurboGrafx 16/USA" --filter "- *{\(${filter},Japan\)}*" --filter "+ *\(USA\)*" -v
                      rclone copy myrient:"/files/Internet Archive/chadmaster/pcecd-chd-zstd-redump/pcecd-chd-zstd/" "${chdDest}/NEC TurboGrafx 16/Japan" --filter "- *{\(${filter},USA\)}*" --filter "+ *\(Japan\)*" -v
                      # Nintendo GameCube
                      #rclone copy myrient:"/files/Redump/Nintendo - GameCube - NKit RVZ [zstd-19-128k]/" "${chdDest}/Nintendo GameCube/USA" --filter "- *{\(${filter},Japan\)}*" --filter "+ *\(USA\)*" -v
                      #rclone copy myrient:"/files/Redump/Nintendo - GameCube - NKit RVZ [zstd-19-128k]/" "${chdDest}/Nintendo GameCube/Japan" --filter "- *{\(${filter},USA\)}*" --filter "+ *\(Japan\)*" -v
                      # Philips CD-i
                      rclone copy myrient:"/files/Redump/Philips - CD-i/" "${chdDest}/Philips CD-i/USA" --filter "- *{\(${filter},Japan\)}*" --filter "+ *\(USA\)*" -v
                      rclone copy myrient:"/files/Redump/Philips - CD-i/" "${chdDest}/Philips CD-i/Japan" --filter "- *{\(${filter},USA\)}*" --filter "+ *\(Japan\)*" -v
                      rclone copy myrient:"/files/Redump/Philips - CD-i/" "${chdDest}/Philips CD-i/Europe" --filter "- *{\(USA,Beta,Demo,Proto,Japan\)}*" -v
                      # Panasonic 3DO
                      rclone copy myrient:"/files/Internet Archive/chadmaster/3do-chd-zstd-redump/3do-chd-zstd/" "${chdDest}/Panasonic 3DO/USA" --filter "- *{\(${filter},Japan\)}*" --filter "+ *\(USA\)*" -v
                      rclone copy myrient:"/files/Internet Archive/chadmaster/3do-chd-zstd-redump/3do-chd-zstd/" "${chdDest}/Panasonic 3DO/Japan" --filter "- *{\(${filter},USA\)}*" --filter "+ *\(Japan\)*" -v
                      # Sega CD
                      rclone copy myrient:"/files/Internet Archive/chadmaster/chd_segacd/CHD-SegaCD-NTSC/" "${chdDest}/Sega CD/USA" --filter "- *{\(${filter},Japan\)}*" --filter "+ *\(USA\)*" -v
                      rclone copy myrient:"/files/Internet Archive/chadmaster/chd_segacd/CHD-MegaCD-NTSCJ/" "${chdDest}/Sega CD/Japan" --filter "- *{\(${filter},USA\)}*" --filter "+ *\(Japan\)*" -v
                      # Sega Dreamcast
                      rclone copy myrient:"/files/Internet Archive/chadmaster/dc-chd-zstd-redump/dc-chd-zstd/" "${chdDest}/Sega Dreamcast/USA" --filter "- *{\(${filter},Japan\)}*" --filter "+ *\(USA\)*" -v
                      rclone copy myrient:"/files/Internet Archive/chadmaster/dc-chd-zstd-redump/dc-chd-zstd/" "${chdDest}/Sega Dreamcast/Japan" --filter "- *{\(${filter},USA\)}*" --filter "+ *\(Japan\)*" -v
                      # Sega Saturn
                      rclone copy myrient:"/files/Internet Archive/chadmaster/chd_saturn/CHD-Saturn/USA/" "${chdDest}/Sega Saturn/USA" --filter "- *{\(${filter},Japan\)}*" --filter "+ *\(USA\)*" -v
                      rclone copy myrient:"/files/Internet Archive/chadmaster/chd_saturn/CHD-Saturn/Japan/" "${chdDest}/Sega Saturn/Japan" --filter "- *{\(${filter},USA\)}*" --filter "+ *\(Japan\)*" -v
                      rclone copy myrient:"/files/Internet Archive/chadmaster/chd_saturn/CHD-Saturn/Improvements/" "${chdDest}/Sega Saturn/Improvements" --filter "- *{\(${filter}\)}*" -v
                      rclone copy myrient:"/files/Internet Archive/chadmaster/chd_saturn/CHD-Saturn/Translations/" "${chdDest}/Sega Saturn/Translations" --filter "- *{\(${filter}\)}*" -v
                      # SNK NEOGEO CD
                      rclone copy myrient:"/files/Internet Archive/chadmaster/ngcd-chd-zstd-redump/ngcd-chd-zstd/" "${chdDest}/SNK NeoGeo CD" --filter "- *{\(${filter}\)}*" -v
                      # Sony Playstation
                      rclone copy myrient:"/files/Internet Archive/chadmaster/chd_psx/CHD-PSX-USA/" "${chdDest}/Sony Playstation/USA" --filter "- *{\(${filter},Japan\)}*" --filter "+ *\(USA\)*" -v
                      rclone copy myrient:"/files/Internet Archive/chadmaster/chd_psx_jap/CHD-PSX-JAP/" "${chdDest}/Sony Playstation/Japan" --filter "- *{\(${filter},USA\)}*" --filter "+ *\(Japan\)*" -v
                      rclone copy myrient:"/files/Internet Archive/chadmaster/chd_psx_jap_p2/CHD-PSX-JAP/" "${chdDest}/Sony Playstation/Japan" --filter "- *{\(${filter},USA\)}*" --filter "+ *\(Japan\)*" -v
                      rclone copy myrient:"/files/Internet Archive/chadmaster/chd_psx/CHD-PSX-Improvements/" "${chdDest}/Sony Playstation/Improvements" --filter "- *{\(${filter}\)}*" -v
                      #rclone copy myrient:"/files/Redump/Sony - PlayStation 2/" "${chdDest}/Sony Playstation 2/USA" --filter "- *{\(${filter},Japan\)}*" --filter "+ *\(USA\)*" -v
                      #rclone copy myrient:"/files/Redump/Sony - PlayStation 2/" "${chdDest}/Sony Playstation 2/Japan" --filter "- *{\(${filter},USA\)}*" --filter "+ *\(Japan\)*" -v
                      # Sony PSP
                      rclone copy myrient:"/files/Internet Archive/chadmaster/psp-chd-zstd-redump-part1/psp-chd-zstd/" "${chdDest}/Sony PSP/USA" --filter "- *{\(${filter},Japan\)}*" --filter "+ *\(USA\)*" -v
                      rclone copy myrient:"/files/Internet Archive/chadmaster/psp-chd-zstd-redump-part2/psp-chd-zstd/" "${chdDest}/Sony PSP/USA" --filter "- *{\(${filter},Japan\)}*" --filter "+ *\(USA\)*" -v
                      rclone copy myrient:"/files/Internet Archive/chadmaster/psp-chd-zstd-redump-part1/psp-chd-zstd/" "${chdDest}/Sony PSP/Japan" --filter "- *{\(${filter},USA\)}*" --filter "+ *\(Japan\)*" -v
                      rclone copy myrient:"/files/Internet Archive/chadmaster/psp-chd-zstd-redump-part2/psp-chd-zstd/" "${chdDest}/Sony PSP/Japan" --filter "- *{\(${filter},USA\)}*" --filter "+ *\(Japan\)*" -v
                    '';
                });
            };
          };
          rclone-myrient-mame = {
            Unit = {
              Description = "Download mame from Myrient";
            };
            Service = {
              Type = "oneshot";
              ExecStart =
                with pkgs;
                lib.getExe (writeShellApplication {
                  name = "rclone-myrient-mame";
                  runtimeInputs = [
                    rclone
                  ];
                  text =
                    let
                      rcloneOpts = {
                        command = "copy";
                        source = "myrient:/files/MAME/";
                        destination = "/mnt/crusader/Games/Backups/Myrient/MAME";
                        args = "--filter-from ${rcloneOpts.filter}";
                        filter = writeText "rclone-myrient-mame-filter" ''
                          + *(merged)/**
                          + *(bios-devices)/**
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
          rclone-myrient-hbmame = {
            Unit = {
              Description = "Download hbmame from Myrient";
            };
            Service = {
              Type = "oneshot";
              ExecStart =
                with pkgs;
                lib.getExe (writeShellApplication {
                  name = "rclone-myrient-hbmame";
                  runtimeInputs = [
                    rclone
                  ];
                  text =
                    let
                      rcloneOpts = {
                        command = "copy";
                        source = "myrient:/files/HBMAME/";
                        destination = "/mnt/crusader/Games/Backups/Myrient/HBMAME";
                        args = "--filter-from ${rcloneOpts.filter}";
                        filter = writeText "rclone-myrient-mame-filter" ''
                          + *(merged)/**
                          + *(bios-devices)/**
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
                        destination = "/mnt/crusader/Games/Backups/Myrient/No-Intro";
                        args = "--filter-from ${rcloneOpts.filter}";
                        filter = writeText "rclone-myrient-nointro-filter" ''
                          + SNK - NeoGeo Pocket**/**
                          + Sharp - X68000 (Flux)/**
                          + Sega - SG-1000/**
                          + Sega - PICO/**
                          + Sega - Mega Drive - Genesis**/**
                          + Sega - Master System - Mark III/**
                          + Sega - Game Gear/**
                          + Sega - 32X/**
                          + Nintendo - Virtual Boy**/**
                          + Nintendo - Super Nintendo Entertainment System**/**
                          + Nintendo - Satellaview/**
                          + Nintendo - Nintendo Entertainment System**/**
                          + Nintendo - Nintendo DSi (Digital) (CDN) (Decrypted)/**
                          + Nintendo - Nintendo DSi (Decrypted)/**
                          + Nintendo - Nintendo DS (Download Play)/**
                          + Nintendo - Nintendo DS (Decrypted)/**
                          + Nintendo - Nintendo DS (Decrypted) (Private)/**
                          + Nintendo - Nintendo 64DD/**
                          + Nintendo - Nintendo 64 (BigEndian)**/**
                          + Nintendo - Game Boy**/**
                          + Nintendo - Family Computer Network System/**
                          + Nintendo - Family Computer Disk System (QD)/**
                          + Nintendo - Family Computer Disk System (FDS)/**
                          + NEC - PC-98**/**
                          + NEC - PC Engine**/**
                          + Fujitsu - FM Towns**/**
                          + Commodore - Commodore 64**/**
                          + Commodore - Amiga**/**
                          + Atari - Lynx**/**
                          + Atari - Jaguar**/**
                          + Atari - 7800**/**
                          + Atari - 5200/**
                          + Atari - 2600/**
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
        };
        timers = {
          rclone-myrient-nointro = {
            Install.WantedBy = [ "multi-user.target" ];
            Timer = {
              OnCalendar = "Thu *-*-1..7 02:00:00 ${osConfig.time.timeZone}";
              Persistent = true;
            };
          };
        };
      };
    };
}
