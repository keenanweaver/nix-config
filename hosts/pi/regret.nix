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
                      filter = "Australia,Brazil,China,Europe,France,Germany,India,Italy,Korea,Netherlands,Poland,Portugal,Russia,Scandinavia,Spain,Sweden,UK,Beta,Demo,Proto";
                    in
                    ''
                      # NEC TURBOGRAFX 16
                      rclone copy myrient:"/files/Internet Archive/chadmaster/pcecd-chd-zstd-redump/tgcd-chd-zstd/" "/mnt/crusader/Games/Rom/CHD/NEC TurboGrafx 16/USA" --filter "- *{${filter}},Japan*" --filter "+ *USA*" -v
                      rclone copy myrient:"/files/Internet Archive/chadmaster/pcecd-chd-zstd-redump/pcecd-chd-zstd/" "/mnt/crusader/Games/Rom/CHD/NEC TurboGrafx 16/Japan" --filter "- *{${filter}},USA*" --filter "+ *Japan*" -v
                      rclone copy myrient:"/files/Internet Archive/chadmaster/ngcd-chd-zstd-redump/ngcd-chd-zstd/" "/mnt/crusader/Games/Rom/CHD/SNK NeoGeo CD" --filter "- *{${filter}}*" -v
                      # Nintendo GameCube
                      rclone copy myrient:"/files/Redump/Nintendo - GameCube - NKit RVZ [zstd-19-128k]/" "/mnt/crusader/Games/Rom/CHD/Nintendo GameCube/USA" --filter "- *{${filter}},Japan*" --filter "+ *USA*" -v
                      rclone copy myrient:"/files/Redump/Nintendo - GameCube - NKit RVZ [zstd-19-128k]/" "/mnt/crusader/Games/Rom/CHD/Nintendo GameCube/Japan" --filter "- *{${filter}},USA*" --filter "+ *Japan*" -v
                      # Panasonic 3DO
                      rclone copy myrient:"/files/Internet Archive/chadmaster/3do-chd-zstd-redump/3do-chd-zstd/" "/mnt/crusader/Games/Rom/CHD/Panasonic 3DO/USA" --filter "- *{${filter}},Japan*" --filter "+ *USA*" -v
                      rclone copy myrient:"/files/Internet Archive/chadmaster/3do-chd-zstd-redump/3do-chd-zstd/" "/mnt/crusader/Games/Rom/CHD/Panasonic 3DO/Japan" --filter "- *{${filter}},USA*" --filter "+ *Japan*" -v
                      # Sega CD
                      rclone copy myrient:"/files/Internet Archive/chadmaster/chd_segacd/CHD-SegaCD-NTSC/" "/mnt/crusader/Games/Rom/CHD/Sega CD/USA" --filter "- *{${filter}},Japan*" --filter "+ *USA*" -v
                      rclone copy myrient:"/files/Internet Archive/chadmaster/chd_segacd/CHD-MegaCD-NTSCJ/" "/mnt/crusader/Games/Rom/CHD/Sega CD/Japan" --filter "- *{${filter}},USA*" --filter "+ *Japan*" -v
                      # Sega Dreamcast
                      rclone copy myrient:"/files/Internet Archive/chadmaster/dc-chd-zstd-redump/dc-chd-zstd/" "/mnt/crusader/Games/Rom/CHD/Sega Dreamcast/USA" --filter "- *{${filter}},Japan*" --filter "+ *USA*" -v
                      rclone copy myrient:"/files/Internet Archive/chadmaster/dc-chd-zstd-redump/dc-chd-zstd/" "/mnt/crusader/Games/Rom/CHD/Sega Dreamcast/Japan" --filter "- *{${filter}},USA*" --filter "+ *Japan*" -v
                      # Sega Saturn
                      rclone copy myrient:"/files/Internet Archive/chadmaster/chd_saturn/CHD-Saturn/USA/" "/mnt/crusader/Games/Rom/CHD/Sega Saturn/USA" --filter "- *{${filter}},Japan*" --filter "+ *USA*" -v
                      rclone copy myrient:"/files/Internet Archive/chadmaster/chd_saturn/CHD-Saturn/Japan/" "/mnt/crusader/Games/Rom/CHD/Sega Saturn/Japan" --filter "- *{${filter}},USA*" --filter "+ *Japan*" -v
                      rclone copy myrient:"/files/Internet Archive/chadmaster/chd_saturn/CHD-Saturn/Improvements/" "/mnt/crusader/Games/Rom/CHD/Sega Saturn/Improvements" --filter "- *{${filter}}*" -v
                      rclone copy myrient:"/files/Internet Archive/chadmaster/chd_saturn/CHD-Saturn/Translations/" "/mnt/crusader/Games/Rom/CHD/Sega Saturn/Translations" --filter "- *{${filter}}*" -v
                      # Sony Playstation
                      rclone copy myrient:"/files/Internet Archive/chadmaster/chd_psx/CHD-PSX-USA/" "/mnt/crusader/Games/Rom/CHD/Sony Playstation/USA" --filter "- *{${filter}},Japan*" --filter "+ *USA*" -v
                      rclone copy myrient:"/files/Internet Archive/chadmaster/chd_psx_jap/CHD-PSX-JAP/" "/mnt/crusader/Games/Rom/CHD/Sony Playstation/Japan" --filter "- *{${filter}},USA*" --filter "+ *Japan*" -v
                      rclone copy myrient:"/files/Internet Archive/chadmaster/chd_psx_jap_p2/CHD-PSX-JAP/" "/mnt/crusader/Games/Rom/CHD/Sony Playstation/Japan" --filter "- *{${filter}},USA*" --filter "+ *Japan*" -v
                      rclone copy myrient:"/files/Internet Archive/chadmaster/chd_psx/CHD-PSX-Improvements/" "/mnt/crusader/Games/Rom/CHD/Sony Playstation/Improvements" --filter "- *{${filter}}*" -v
                      # Sony PSP
                      rclone copy myrient:"/files/Internet Archive/chadmaster/psp-chd-zstd-redump-part1/psp-chd-zstd/" "/mnt/crusader/Games/Rom/CHD/Sony PSP/USA" --filter "- *{${filter}},Japan*" --filter "+ *USA*" -v
                      rclone copy myrient:"/files/Internet Archive/chadmaster/psp-chd-zstd-redump-part2/psp-chd-zstd/" "/mnt/crusader/Games/Rom/CHD/Sony PSP/USA" --filter "- *{${filter}},Japan*" --filter "+ *USA*" -v
                      rclone copy myrient:"/files/Internet Archive/chadmaster/psp-chd-zstd-redump-part1/psp-chd-zstd/" "/mnt/crusader/Games/Rom/CHD/Sony PSP/Japan" --filter "- *{${filter}},USA*" --filter "+ *Japan*" -v
                      rclone copy myrient:"/files/Internet Archive/chadmaster/psp-chd-zstd-redump-part2/psp-chd-zstd/" "/mnt/crusader/Games/Rom/CHD/Sony PSP/Japan" --filter "- *{${filter}},USA*" --filter "+ *Japan*" -v
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
                        source = "myrient:/files/No-Intro";
                        destination = "/mnt/crusader/Games/Backups/Myrient/No-Intro";
                        args = "--filter-from ${rcloneOpts.filter}";
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
