{ lib, username, ... }:
{
  imports = [
    # System
    ./disko.nix
    ./hardware-configuration.nix
    #./impermanence.nix
    # Profiles
    ../../modules
  ];

  # Custom modules
  server.enable = true;
  flatpak.enable = lib.mkForce false;

  boot = {
    initrd = {
      availableKernelModules = [
        "uhci_hcd"
        "ehci_pci"
        "ahci"
        "virtio_pci"
        "sr_mod"
        "virtio_blk"
      ];
    };
    kernelModules = [ "kvm-intel" ];
    lanzaboote = {
      enable = lib.mkForce false;
    };
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      systemd-boot.enable = true;
    };
    supportedFilesystems = [
      "nfs"
      "btrfs"
    ];
  };

  hardware = {
    cpu.intel.updateMicrocode = true;
  };

  networking = {
    hostName = "nixos-unraid";
    wireless.enable = false;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  services = {
    btrfs.autoScrub.enable = lib.mkForce false;
    clamav = {
      daemon = {
        enable = lib.mkForce false;
      };
      fangfrisch = {
        enable = lib.mkForce false;
      };
      scanner = {
        enable = lib.mkForce false;
      };
      updater = {
        enable = lib.mkForce false;
      };
    };
    opensnitch = {
      enable = lib.mkForce false;
    };
  };

  system.stateVersion = "23.11";

  home-manager.users.${username} =
    {
      config,
      inputs,
      username,
      pkgs,
      ...
    }:
    let
      unraid = "/mnt/crusader";
    in
    {
      imports = [ inputs.sops-nix.homeManagerModules.sops ];

      home = {
        file = {
          lgogdownloader-blacklist = {
            enable = true;
            text = ''
              #!/usr/bin/env bash
              cd ${unraid}/Games/Other/GOG
              for i in $(/run/current-system/sw/bin/ls -d */); do echo "Rp /''${i%%}.*"; done > /home/${username}/.config/lgogdownloader/blacklist.txt
            '';
            target = ".local/bin/lgogdownloader-blacklist.sh";
            executable = true;
          };
          lgogdownloader-cleanup = {
            enable = true;
            text = ''
              #!/usr/bin/env bash
              for orphan in $(cat /home/${username}/orphans.txt)
              do
                rm $orphan
              done
            '';
            target = ".local/bin/lgogdownloader-cleanup.sh";
            executable = true;
          };
        };

        packages = with pkgs; [
          internetarchive
          lgogdownloader
          ntfy-sh
        ];
      };
      systemd = {
        user = {
          services = {
            /*
              "chd_3do" = {
              Unit = { Description = "Download 'chd_3do' from Internet Archive"; };
              Service = {
                ExecStartPre = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=grey_exclamation ${config.sops.secrets.unraid.ntfy.url.path} '[Start] chd_3do'";
                ExecStart = "${pkgs.internetarchive}/bin/ia download chd_3do --destdir='${unraid}/Games/Games/Rom/Redump/Panasonic 3DO/CHD' --no-directories";
                ExecStartPost = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=heavy_check_mark ${config.sops.secrets.unraid.ntfy.url.path} '[End] chd_3do'";
                Type = "oneshot";
              };
                };
            */
            "chd_dc" = {
              Unit = {
                Description = "Download 'chd_dc' from Internet Archive";
              };
              Service = {
                ExecStartPre = "${pkgs.ntfy-sh}/bin/ntfy pub -u $(cat ${config.sops.secrets."unraid/ntfy/user".path}):${config.sops.secrets.unraid.ntfy.password.path} --tags=grey_exclamation ${config.sops.secrets.unraid.ntfy.url.path} '[Start] chd_dc'";
                ExecStart = "${pkgs.internetarchive}/bin/ia download chd_dc --destdir='${unraid}/Games/Rom/Redump/Sega Dreamcast/CHD' --no-directories";
                ExecStartPost = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=heavy_check_mark ${config.sops.secrets.unraid.ntfy.url.path} '[End] chd_dc'";
                Type = "oneshot";
              };
            };
            /*
              "chd_neogeocd" = {
              Unit = {
                Description = "Download 'chd_neogeocd' from Internet Archive";
              };
              Service = {
                ExecStartPre = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=grey_exclamation ${config.sops.secrets.unraid.ntfy.url.path} '[Start] chd_neogeocd'";
                ExecStart = "${pkgs.internetarchive}/bin/ia download chd_neogeocd --destdir='${unraid}/Games/Rom/Redump/SNK Neo Geo CD/CHD' --no-directories";
                ExecStartPost = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=heavy_check_mark ${config.sops.secrets.unraid.ntfy.url.path} '[End] chd_neogeocd'";
                Type = "oneshot";
              };
                };
            */
            /*
              "chd_pcecd" = {
              Unit = {
                Description = "Download 'chd_pcecd' from Internet Archive";
              };
              Service = {
                ExecStartPre = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=grey_exclamation ${config.sops.secrets.unraid.ntfy.url.path} '[Start] chd_pcecd'";
                ExecStart = "${pkgs.internetarchive}/bin/ia download chd_pcecd --destdir='${unraid}/Games/Rom/Redump/NEC PC Engine/CHD' --no-directories";
                ExecStartPost = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=heavy_check_mark ${config.sops.secrets.unraid.ntfy.url.path} '[End] chd_pcecd'";
                Type = "oneshot";
              };
                };
            */
            /*
              "chd_psx" = {
              Unit = {
                Description = "Download 'chd_psx' from Internet Archive";
              };
              Service = {
                ExecStartPre = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=grey_exclamation ${config.sops.secrets.unraid.ntfy.url.path} '[Start] chd_psx'";
                ExecStart = [
                  "${pkgs.internetarchive}/bin/ia download chd_psx --destdir='${unraid}/Games/Rom/Redump/Sony Playstation/CHD' --no-directories"
                  "${pkgs.internetarchive}/bin/ia download chd_psx_eur --destdir='${unraid}/Games/Rom/Redump/Sony Playstation/CHD' --no-directories"
                  "${pkgs.internetarchive}/bin/ia download chd_psx_jap --destdir='${unraid}/Games/Rom/Redump/Sony Playstation/CHD' --no-directories"
                  "${pkgs.internetarchive}/bin/ia download chd_psx_jap_p2 --destdir='${unraid}/Games/Rom/Redump/Sony Playstation/CHD' --no-directories"
                  "${pkgs.internetarchive}/bin/ia download chd_psx_misc --destdir='${unraid}/Games/Rom/Redump/Sony Playstation/CHD' --no-directories"
                ];
                ExecStartPost = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=heavy_check_mark ${config.sops.secrets.unraid.ntfy.url.path} '[End] chd_psx'";
                Type = "oneshot";
              };
                };
            */
            /*
              "chd_saturn" = {
              Unit = {
                Description = "Download 'chd_saturn' from Internet Archive";
              };
              Service = {
                ExecStartPre = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=grey_exclamation ${config.sops.secrets.unraid.ntfy.url.path} '[Start] chd_saturn'";
                ExecStart = "${pkgs.internetarchive}/bin/ia download chd_saturn --destdir='${unraid}/Games/Rom/Redump/Sega Saturn/CHD' --no-directories";
                ExecStartPost = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=heavy_check_mark ${config.sops.secrets.unraid.ntfy.url.path} '[End] chd_saturn'";
                Type = "oneshot";
              };
                };
            */
            /*
              "chd_segacd" = {
              Unit = {
                Description = "Download 'chd_segacd' from Internet Archive";
              };
              Service = {
                ExecStartPre = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=grey_exclamation ${config.sops.secrets.unraid.ntfy.url.path} '[Start] chd_segacd'";
                ExecStart = "${pkgs.internetarchive}/bin/ia download chd_segacd --destdir='${unraid}/Games/Rom/Redump/Sega CD/CHD' --no-directories";
                ExecStartPost = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=heavy_check_mark ${config.sops.secrets.unraid.ntfy.url.path} '[End] chd_segacd'";
                Type = "oneshot";
              };
                };
            */
            "htgdb-gamepacks" = {
              Unit = {
                Description = "Download 'htgdb-gamepacks' from Internet Archive";
              };
              Service = {
                ExecStartPre = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=grey_exclamation ${config.sops.secrets.unraid.ntfy.url.path} '[Start] htgdb-gamepacks'";
                ExecStart = "${pkgs.internetarchive}/bin/ia download htgdb-gamepacks --destdir='${unraid}/Games/Rom/Other/HTGDB' --no-directories";
                ExecStartPost = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=heavy_check_mark ${config.sops.secrets.unraid.ntfy.url.path} '[End] htgdb-gamepacks'";
                Type = "oneshot";
              };
            };
            "joshw" = {
              Unit = {
                Description = "Download music packs from joshw";
              };
              Service = {
                ExecStartPre = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=grey_exclamation ${config.sops.secrets.unraid.ntfy.url.path} '[Start] joshw'";
                ExecStart = [
                  # http://2sf.joshw.info
                  "${pkgs.wget}/bin/wget -e robots=off --no-check-certificate --no-cache -R '.DS_Store,Thumbs.db,thumbcache.db,desktop.ini,_macosx,index.html*' -c -w 1 -r -A '7z,dll,zip' --timestamping --random-wait -P '${unraid}/Media/Audio/Music/VGM/Nintendo DS' 'http://2sf.joshw.info'"
                  # http://3do.joshw.info
                  "${pkgs.wget}/bin/wget -e robots=off --no-check-certificate --no-cache -R '.DS_Store,Thumbs.db,thumbcache.db,desktop.ini,_macosx,index.html*' -c -w 1 -r -A '7z,dll,zip' --timestamping --random-wait -P '${unraid}/Media/Audio/Music/VGM/3DO' 'http://3do.joshw.info'"
                  # http://dsf.joshw.info
                  "${pkgs.wget}/bin/wget -e robots=off --no-check-certificate --no-cache -R '.DS_Store,Thumbs.db,thumbcache.db,desktop.ini,_macosx,index.html*' -c -w 1 -r -A '7z,dll,zip' --timestamping --random-wait -P '${unraid}/Media/Audio/Music/VGM/Sega Dreamcast' 'http://dsf.joshw.info'"
                  # http://fmtowns.joshw.info
                  "${pkgs.wget}/bin/wget -e robots=off --no-check-certificate --no-cache -R '.DS_Store,Thumbs.db,thumbcache.db,desktop.ini,_macosx,index.html*' -c -w 1 -r -A '7z,dll,zip' --timestamping --random-wait -P '${unraid}/Media/Audio/Music/VGM/FM Towns' 'http://fmtowns.joshw.info'"
                  # http://gbs.joshw.info
                  "${pkgs.wget}/bin/wget -e robots=off --no-check-certificate --no-cache -R '.DS_Store,Thumbs.db,thumbcache.db,desktop.ini,_macosx,index.html*' -c -w 1 -r -A '7z,dll,zip' --timestamping --random-wait -P '${unraid}/Media/Audio/Music/VGM/Nintendo Gameboy' 'http://gbs.joshw.info'"
                  # http://gcn.joshw.info
                  "${pkgs.wget}/bin/wget -e robots=off --no-check-certificate --no-cache -R '.DS_Store,Thumbs.db,thumbcache.db,desktop.ini,_macosx,index.html*' -c -w 1 -r -A '7z,dll,zip' --timestamping --random-wait -P '${unraid}/Media/Audio/Music/VGM/Nintendo GameCube' 'http://gcn.joshw.info'"
                  # http://gsf.joshw.info
                  "${pkgs.wget}/bin/wget -e robots=off --no-check-certificate --no-cache -R '.DS_Store,Thumbs.db,thumbcache.db,desktop.ini,_macosx,index.html*' -c -w 1 -r -A '7z,dll,zip' --timestamping --random-wait -P '${unraid}/Media/Audio/Music/VGM/Nintendo Gameboy Advance' 'http://gsf.joshw.info'"
                  # http://hes.joshw.info
                  "${pkgs.wget}/bin/wget -e robots=off --no-check-certificate --no-cache -R '.DS_Store,Thumbs.db,thumbcache.db,desktop.ini,_macosx,index.html*' -c -w 1 -r -A '7z,dll,zip' --timestamping --random-wait -P '${unraid}/Media/Audio/Music/VGM/PC Engine' 'http://hes.joshw.info'"
                  # http://hoot.joshw.info
                  "${pkgs.wget}/bin/wget -e robots=off --no-check-certificate --no-cache -R '.DS_Store,Thumbs.db,thumbcache.db,desktop.ini,_macosx,index.html*' -c -w 1 -r -A '7z,dll,zip' --timestamping --random-wait -P '${unraid}/Media/Audio/Music/VGM' 'http://hoot.joshw.info'"
                  # http://ncd.joshw.info
                  "${pkgs.wget}/bin/wget -e robots=off --no-check-certificate --no-cache -R '.DS_Store,Thumbs.db,thumbcache.db,desktop.ini,_macosx,index.html*' -c -w 1 -r -A '7z,dll,zip' --timestamping --random-wait -P '${unraid}/Media/Audio/Music/VGM/Neo Geo CD' 'http://ncd.joshw.info'"
                  # http://nsf.joshw.info
                  "${pkgs.wget}/bin/wget -e robots=off --no-check-certificate --no-cache -R '.DS_Store,Thumbs.db,thumbcache.db,desktop.ini,_macosx,index.html*' -c -w 1 -r -A '7z,dll,zip' --timestamping --random-wait -P '${unraid}/Media/Audio/Music/VGM/Nintendo Entertainment System' 'http://nsf.joshw.info'"
                  # http://psf2.joshw.info
                  "${pkgs.wget}/bin/wget -e robots=off --no-check-certificate --no-cache -R '.DS_Store,Thumbs.db,thumbcache.db,desktop.ini,_macosx,index.html*' -c -w 1 -r -A '7z,dll,zip' --timestamping --random-wait -P '${unraid}/Media/Audio/Music/VGM/Sony Playstation 2' 'http://psf2.joshw.info'"
                  # http://psf.joshw.info
                  "${pkgs.wget}/bin/wget -e robots=off --no-check-certificate --no-cache -R '.DS_Store,Thumbs.db,thumbcache.db,desktop.ini,_macosx,index.html*' -c -w 1 -r -A '7z,dll,zip' --timestamping --random-wait -P '${unraid}/Media/Audio/Music/VGM/Sony Playstation' 'http://psf.joshw.info'"
                  # http://s98.joshw.info
                  "${pkgs.wget}/bin/wget -e robots=off --no-check-certificate --no-cache -R '.DS_Store,Thumbs.db,thumbcache.db,desktop.ini,_macosx,index.html*' -c -w 1 -r -A '7z,dll,zip' --timestamping --random-wait -P '${unraid}/Media/Audio/Music/VGM/S98' 'http://s98.joshw.info'"
                  # http://smd.joshw.info
                  "${pkgs.wget}/bin/wget -e robots=off --no-check-certificate --no-cache -R '.DS_Store,Thumbs.db,thumbcache.db,desktop.ini,_macosx,index.html*' -c -w 1 -r -A '7z,dll,zip' --timestamping --random-wait -P '${unraid}/Media/Audio/Music/VGM/Sega Genesis' 'http://smd.joshw.info'"
                  # http://spc.joshw.info
                  "${pkgs.wget}/bin/wget -e robots=off --no-check-certificate --no-cache -R '.DS_Store,Thumbs.db,thumbcache.db,desktop.ini,_macosx,index.html*' -c -w 1 -r -A '7z,dll,zip' --timestamping --random-wait -P '${unraid}/Media/Audio/Music/VGM/Super Nintendo Entertainment System' 'http://spc.joshw.info'"
                  # http://ssf.joshw.info
                  "${pkgs.wget}/bin/wget -e robots=off --no-check-certificate --no-cache -R '.DS_Store,Thumbs.db,thumbcache.db,desktop.ini,_macosx,index.html*' -c -w 1 -r -A '7z,dll,zip' --timestamping --random-wait -P '${unraid}/Media/Audio/Music/VGM/Sega Saturn' 'http://ssf.joshw.info'"
                  # http://usf.joshw.info
                  "${pkgs.wget}/bin/wget -e robots=off --no-check-certificate --no-cache -R '.DS_Store,Thumbs.db,thumbcache.db,desktop.ini,_macosx,index.html*' -c -w 1 -r -A '7z,dll,zip' --timestamping --random-wait -P '${unraid}/Media/Audio/Music/VGM/Nintendo 64' 'http://usf.joshw.info'"
                ];
                ExecStartPost = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=heavy_check_mark ${config.sops.secrets.unraid.ntfy.url.path} '[End] joshw'";
                Type = "oneshot";
              };
            };
            "idgames-archive" = {
              Unit = {
                Description = "Download idgames archive";
              };
              Service = {
                ExecStartPre = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=grey_exclamation ${config.sops.secrets.unraid.ntfy.url.path} '[Start] idgames Archive'";
                ExecStart = "${pkgs.wget}/bin/wget -e robots=off --no-check-certificate -nH --no-cache -R '.DS_Store,Thumbs.db,thumbcache.db,desktop.ini,_macosx,index.html*' -c -w 1 --random-wait --cut-dirs=2 -P '${unraid}/Games/Games/Doom/idgames' -q -r -l 6 --no-parent -nc -a -nv 'https://youfailit.net/pub/idgames'";
                ExecStartPost = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=heavy_check_mark ${config.sops.secrets.unraid.ntfy.url.path} '[End] idgames Archive'";
                Type = "oneshot";
              };
            };
            "lgogdownloader" = {
              Unit = {
                Description = "Download & update GOG offline installers";
              };
              Service = {
                ExecStartPre = [
                  "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=grey_exclamation ${config.sops.secrets.unraid.ntfy.url.path} '[Start] lgogdownloader'"
                ];
                ExecStart = [
                  "${pkgs.lgogdownloader}/bin/lgogdownloader --directory=${unraid}/Games/Other/GOG --download --platform=w+l --language=en --save-serials --exclude l,p --threads 1 --info-threads 1 --retries 6 --report"
                ];
                ExecStartPost = [
                  "${pkgs.bash}/bin/bash /home/${config.sops.secrets.unraid.ntfy.user.path}/.local/bin/lgogdownloader-blacklist.sh"
                  "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=heavy_check_mark ${config.sops.secrets.unraid.ntfy.url.path} '[End] lgogdownloader'"
                ];
                Type = "oneshot";
              };
            };
            "lgogdownloader-cleanup" = {
              Unit = {
                Description = "Clean up old GOG offline installers";
              };
              Service = {
                ExecStartPre = [
                  "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=grey_exclamation ${config.sops.secrets.unraid.ntfy.url.path} '[Start] lgogdownloader-cleanup'"
                  "${pkgs.lgogdownloader}/bin/lgogdownloader --directory=${unraid}/Games/Other/GOG --update-cache --threads 1 --info-threads 1"
                  "${pkgs.lgogdownloader}/bin/lgogdownloader --directory=${unraid}/Games/Other/GOG --use-cache --check-orphans > /home/${config.sops.secrets.unraid.ntfy.user.path}/orphans.txt"
                ];
                ExecStart = [
                  "${pkgs.bash}/bin/bash /home/${config.sops.secrets.unraid.ntfy.user.path}/.local/bin/lgogdownloader-cleanup.sh"
                ];
                ExecStartPost = [
                  "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=heavy_check_mark ${config.sops.secrets.unraid.ntfy.url.path} '[End] lgogdownloader-cleanup'"
                ];
                Type = "oneshot";
              };
            };
            /*
              "mame" = {
              Unit = { Description = "Download mame from Internet Archive"; };
              Service = {
                ExecStartPre = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=grey_exclamation ${config.sops.secrets.unraid.ntfy.url.path} '[Start] mame'";
                ExecStart = [
                  "${pkgs.internetarchive}/bin/ia download mame-merged --destdir='${unraid}/Games/Rom/MAME/merged' --no-directories"
                  "${pkgs.internetarchive}/bin/ia download mame-sl --destdir='${unraid}/Games/Rom/MAME/sl' --no-directories"
                  "${pkgs.internetarchive}/bin/ia download mame-support --destdir='${unraid}/Games/Rom/MAME/support' --no-directories"
                  "${pkgs.internetarchive}/bin/ia download MAME_0.225_CHDs_merged --destdir='${unraid}/Games/Rom/MAME/CHD' --no-directories"
                ];
                ExecStartPost = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=heavy_check_mark ${config.sops.secrets.unraid.ntfy.url.path} '[End] mame'";
                Type = "oneshot";
              };
                };
            */
            "modland" = {
              Unit = {
                Description = "Download modland";
              };
              Service = {
                ExecStartPre = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=grey_exclamation ${config.sops.secrets.unraid.ntfy.url.path} '[Start] modland'";
                ExecStart = "${pkgs.wget}/bin/wget -R '.DS_Store,Thumbs.db,thumbcache.db,desktop.ini,_macosx,index.html*' -nH -nc --no-cache --no-check-certificate -e robots=off -c --random-wait -P '${unraid}/Media/Audio/Music/Tracker/ModLand' -r -l 6 --no-parent 'ftp://modland.com/pub'";
                ExecStartPost = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=heavy_check_mark ${config.sops.secrets.unraid.ntfy.url.path} '[End] modland'";
                Type = "oneshot";
              };
            };
            /*
              "nintendo-3ds-complete-collection" = {
              Unit = {
                Description = "Download 'nintendo-3ds-complete-collection' from Internet Archive";
              };
              Service = {
                ExecStartPre = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=grey_exclamation ${config.sops.secrets.unraid.ntfy.url.path} '[Start] nintendo-3ds-complete-collection'";
                ExecStart = [
                  "${pkgs.internetarchive}/bin/ia download nintendo-3ds-complete-collection --destdir='${unraid}/Games/Rom/Other/Nintendo 3DS' --no-directories"
                  "${pkgs.internetarchive}/bin/ia download nintendo-3ds-complete-collection-pt2 --destdir='${unraid}/Games/Rom/Other/Nintendo 3DS' --no-directories"
                  "${pkgs.internetarchive}/bin/ia download nintendo-3ds-eshop-complete-collection --destdir='${unraid}/Games/Rom/Other/Nintendo 3DS' --no-directories"
                ];
                ExecStartPost = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=heavy_check_mark ${config.sops.secrets.unraid.ntfy.url.path} '[End] nintendo-3ds-complete-collection'";
                Type = "oneshot";
              };
                };
            */
            /*
              "nintendo-ds" = {
              Unit = {
                Description = "Download 'nintendo-ds' from Internet Archive";
              };
              Service = {
                ExecStartPre = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=grey_exclamation ${config.sops.secrets.unraid.ntfy.url.path} '[Start] nintendo-ds'";
                ExecStart = [
                  "${pkgs.internetarchive}/bin/ia download no-ndsdec2021 --destdir='${unraid}/Games/Rom/No-Intro/Nintendo DS' --no-directories"
                  "${pkgs.internetarchive}/bin/ia download no-intro-nintendo-nintendo-ds-download-play_202207 --destdir='${unraid}/Games/Rom/No-Intro/Nintendo DS' --no-directories"
                  "${pkgs.internetarchive}/bin/ia download No-Intro_Nintendo_DSi_2018-06-30 --destdir='${unraid}/Games/Rom/No-Intro/Nintendo DS' --no-directories"
                  "${pkgs.internetarchive}/bin/ia download nds_apfix --destdir='${unraid}/Games/Rom/No-Intro/Nintendo DS' --no-directories"
                ];
                ExecStartPost = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=heavy_check_mark ${config.sops.secrets.unraid.ntfy.url.path} '[End] nintendo-ds'";
                Type = "oneshot";
              };
                };
            */
            "ni-roms" = {
              Unit = {
                Description = "Download 'ni-roms' from Internet Archive";
              };
              Service = {
                ExecStartPre = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=grey_exclamation ${config.sops.secrets.unraid.ntfy.url.path} '[Start] ni-roms'";
                ExecStart = "${pkgs.internetarchive}/bin/ia download ni-roms --destdir='${unraid}/Games/Rom/No-Intro' --no-directories";
                ExecStartPost = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=heavy_check_mark ${config.sops.secrets.unraid.ntfy.url.path} '[End] ni-roms'";
                Type = "oneshot";
              };
            };
            "proper1g1r-collection" = {
              Unit = {
                Description = "Download 'proper1g1r-collection' from Internet Archive";
              };
              Service = {
                ExecStartPre = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=grey_exclamation ${config.sops.secrets.unraid.ntfy.url.path} '[Start] proper1g1r-collection'";
                ExecStart = "${pkgs.internetarchive}/bin/ia download proper1g1r-collection --destdir='${unraid}/Games/Rom/No-Intro/1g1r' --no-directories";
                ExecStartPost = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=heavy_check_mark ${config.sops.secrets.unraid.ntfy.url.path} '[End] proper1g1r-collection'";
                Type = "oneshot";
              };
            };
            "quaddicted" = {
              Unit = {
                Description = "Download Quaddicted maps";
              };
              Service = {
                ExecStartPre = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=grey_exclamation ${config.sops.secrets.unraid.ntfy.url.path} '[Start] Quaddicted'";
                ExecStart = [
                  "${pkgs.wget}/bin/wget -e robots=off --no-check-certificate --no-cache -R '.DS_Store,Thumbs.db,thumbcache.db,desktop.ini,_macosx,index.html*' -c -w 1 -r --timestamping --random-wait -P '${unraid}/Games/Games/Quake/Quake 1/Maps/SP' --no-parent -A 'zip,rar,7z,exe' -l 2 -nH -nd 'https://www.quaddicted.com/filebase/'"
                  "${pkgs.wget}/bin/wget -e robots=off --no-check-certificate --no-cache -R '.DS_Store,Thumbs.db,thumbcache.db,desktop.ini,_macosx,index.html*' -c -w 1 -r --timestamping --random-wait -P '${unraid}/Games/Games/Quake/Quake 1/Maps/MP' --no-parent -A 'zip,rar,7z,exe' -l 2 -nH -nd 'https://www.quaddicted.com/files/maps/multiplayer/'"
                ];
                ExecStartPost = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=heavy_check_mark ${config.sops.secrets.unraid.ntfy.url.path} '[End] Quaddicted'";
                Type = "oneshot";
              };
            };
            "rvz-gc-asia-redump" = {
              Unit = {
                Description = "Download 'rvz-gc-asia-redump' from Internet Archive";
              };
              Service = {
                ExecStartPre = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=grey_exclamation ${config.sops.secrets.unraid.ntfy.url.path} '[Start] rvz-gc-asia-redump'";
                ExecStart = "${pkgs.internetarchive}/bin/ia download rvz-gc-asia-redump --destdir='${unraid}/Games/Rom/Redump/Nintendo GameCube' --no-directories";
                ExecStartPost = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=heavy_check_mark ${config.sops.secrets.unraid.ntfy.url.path} '[End] rvz-gc-asia-redump'";
                Type = "oneshot";
              };
            };
            "rvz-gc-usa-redump" = {
              Unit = {
                Description = "Download 'rvz-gc-usa-redump' from Internet Archive";
              };
              Service = {
                ExecStartPre = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=grey_exclamation ${config.sops.secrets.unraid.ntfy.url.path} '[Start] rvz-gc-usa-redump'";
                ExecStart = "${pkgs.internetarchive}/bin/ia download rvz-gc-usa-redump --destdir='${unraid}/Games/Rom/Redump/Nintendo GameCube' --no-directories";
                ExecStartPost = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=heavy_check_mark ${config.sops.secrets.unraid.ntfy.url.path} '[End] rvz-gc-usa-redump'";
                Type = "oneshot";
              };
            };
            "smspower" = {
              Unit = {
                Description = "Download SMSPower";
              };
              Service = {
                ExecStartPre = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=grey_exclamation ${config.sops.secrets.unraid.ntfy.url.path} '[Start] SMSPower'";
                ExecStart = "${pkgs.wget}/bin/wget -e robots=off --no-check-certificate --no-cache -R '.DS_Store,Thumbs.db,thumbcache.db,desktop.ini,_macosx,index.html*' -c -w 1 -r --timestamping --random-wait -nH --cut-dirs=2 -P '${unraid}/Media/Audio/Music/VGM/Sega Master System & Game Gear' -l 1 -A 'zip' 'https://www.smspower.org/Music/VGMs'";
                ExecStartPost = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=heavy_check_mark ${config.sops.secrets.unraid.ntfy.url.path} '[End] SMSPower'";
                Type = "oneshot";
              };
            };
            "taffersparadise" = {
              Unit = {
                Description = "Download taffersparadise";
              };
              Service = {
                ExecStartPre = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=grey_exclamation ${config.sops.secrets.unraid.ntfy.url.path} '[Start] TaffersParadise'";
                ExecStart = [
                  "${pkgs.wget}/bin/wget -e robots=off --no-check-certificate --no-cache -R '.DS_Store,Thumbs.db,thumbcache.db,desktop.ini,_macosx,index.html*' -c -w 1 -r --timestamping --random-wait -nH -l 1 -A 'zip,rar,7z,exe' --no-parent -P '${unraid}/Games/Games/Thief/Fan Missions/Thief Gold' --cut-dirs=1 'https://www.taffersparadise.co.uk/thief1missions.html'"
                  "${pkgs.wget}/bin/wget -e robots=off --no-check-certificate --no-cache -R '.DS_Store,Thumbs.db,thumbcache.db,desktop.ini,_macosx,index.html*' -c -w 1 -r --timestamping --random-wait -nH -l 1 -A 'zip,rar,7z,exe' --no-parent -P '${unraid}/Games/Games/Thief/Fan Missions/Thief 2' --cut-dirs=1 'https://www.taffersparadise.co.uk/thief2missions.html'"
                  "${pkgs.wget}/bin/wget -e robots=off --no-check-certificate --no-cache -R '.DS_Store,Thumbs.db,thumbcache.db,desktop.ini,_macosx,index.html*' -c -w 1 -r --timestamping --random-wait -nH -l 1 -A 'zip,rar,7z,exe' --no-parent -P '${unraid}/Games/Games/Thief/Fan Missions/Thief 3' --cut-dirs=1 'https://www.taffersparadise.co.uk/thief3missions.html'"
                  "${pkgs.wget}/bin/wget -e robots=off --no-check-certificate --no-cache -R '.DS_Store,Thumbs.db,thumbcache.db,desktop.ini,_macosx,index.html*' -c -w 1 -r --timestamping --random-wait -nH -l 1 -A 'zip,rar,7z,exe' --no-parent -P '${unraid}/Games/Games/Thief/Fan Missions/Dark Mod' --cut-dirs=1 'https://www.taffersparadise.co.uk/darkmodmissions.html'"
                ];
                ExecStartPost = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=heavy_check_mark ${config.sops.secrets.unraid.ntfy.url.path} '[End] TaffersParadise'";
                Type = "oneshot";
              };
            };
            "wii_rvz_usa" = {
              Unit = {
                Description = "Download 'wii_rvz_usa' from Internet Archive";
              };
              Service = {
                ExecStartPre = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=grey_exclamation ${config.sops.secrets.unraid.ntfy.url.path} '[Start] wii_rvz_usa'";
                ExecStart = [
                  "${pkgs.internetarchive}/bin/ia download wii_rvz_usa --destdir='${unraid}/Games/Rom/Redump/Nintendo Wii' --no-directories"
                  "${pkgs.internetarchive}/bin/ia download wii_rvz_usa_p2 --destdir='${unraid}/Games/Rom/Redump/Nintendo Wii' --no-directories"
                  "${pkgs.internetarchive}/bin/ia download wii_rvz_usa_p3 --destdir='${unraid}/Games/Rom/Redump/Nintendo Wii' --no-directories"
                  "${pkgs.internetarchive}/bin/ia download wii_rvz_usa_p4 --destdir='${unraid}/Games/Rom/Redump/Nintendo Wii' --no-directories"
                ];
                ExecStartPost = "${pkgs.ntfy-sh}/bin/ntfy pub -u ${config.sops.secrets.unraid.ntfy.user.path}:${config.sops.secrets.unraid.ntfy.password.path} --tags=heavy_check_mark ${config.sops.secrets.unraid.ntfy.url.path} '[End] wii_rvz_usa'";
                Type = "oneshot";
              };
            };
          };
          timers = {
            /*
              "chd_3do" = {
              Install.WantedBy = [ "timers.target" ];
              Timer = {
                OnCalendar = "*-*-* 6:06:00 America/Chicago";
              };
                };
            */
            "chd_dc" = {
              Install.WantedBy = [ "timers.target" ];
              Timer = {
                OnCalendar = "*-*-* 6:06:00 America/Chicago";
              };
            };
            /*
              "chd_neogeocd" = {
              Install.WantedBy = [ "timers.target" ];
              Timer = {
                OnCalendar = "*-*-* 6:07:00 America/Chicago";
              };
                };
            */
            /*
              "chd_pcecd" = {
              Install.WantedBy = [ "timers.target" ];
              Timer = {
                OnCalendar = "*-*-* 6:08:00 America/Chicago";
              };
                };
            */
            /*
              "chd_saturn" = {
              Install.WantedBy = [ "timers.target" ];
              Timer = {
                OnCalendar = "*-*-* 6:26:00 America/Chicago";
              };
                };
            */
            /*
              "chd_segacd" = {
              Install.WantedBy = [ "timers.target" ];
              Timer = {
                OnCalendar = "*-*-* 6:40:00 America/Chicago";
              };
                };
            */
            "joshw" = {
              Install.WantedBy = [ "timers.target" ];
              Timer = {
                OnCalendar = "Sat *-*-1..7 18:00:00 America/Chicago";
              };
            };
            "htgdb-gamepacks" = {
              Install.WantedBy = [ "timers.target" ];
              Timer = {
                OnCalendar = "*-*-* 6:12:00 America/Chicago";
              };
            };
            "idgames-archive" = {
              Install.WantedBy = [ "timers.target" ];
              Timer = {
                OnCalendar = "Sun *-*-1..7 18:00:00 America/Chicago";
              };
            };
            "lgogdownloader" = {
              Install.WantedBy = [ "timers.target" ];
              Timer = {
                OnCalendar = "*-*-* 10:05:00 America/Chicago";
              };
            };
            "mame" = {
              Install.WantedBy = [ "timers.target" ];
              Timer = {
                OnCalendar = "*-*-* 6:45:00 America/Chicago";
              };
            };
            "modland" = {
              Install.WantedBy = [ "timers.target" ];
              Timer = {
                OnCalendar = "*-01,04,07,10-01 05:00:00 America/Chicago";
              };
            };
            /*
              "nintendo-3ds-complete-collection" = {
                Install.WantedBy = [ "timers.target" ];
                Timer = {
                  OnCalendar = "*-*-* 6:30:00 America/Chicago";
                };
              };
              "nintendo-ds" = {
                Install.WantedBy = [ "timers.target" ];
                Timer = {
                  OnCalendar = "*-*-* 6:30:00 America/Chicago";
                };
                  };
            */
            "ni-roms" = {
              Install.WantedBy = [ "timers.target" ];
              Timer = {
                OnCalendar = "*-*-* 06:00:00 America/Chicago";
              };
            };
            "proper1g1r-collection" = {
              Install.WantedBy = [ "timers.target" ];
              Timer = {
                OnCalendar = "*-*-* 06:00:00 America/Chicago";
              };
            };
            /*
              "rvz-gc-asia-redump" = {
                Install.WantedBy = [ "timers.target" ];
                Timer = {
                  OnCalendar = "*-*-* 06:00:00 America/Chicago";
                };
              };
              "rvz-gc-usa-redump" = {
                Install.WantedBy = [ "timers.target" ];
                Timer = {
                  OnCalendar = "*-*-* 06:00:00 America/Chicago";
                };
                  };
            */
            "smspower" = {
              Install.WantedBy = [ "timers.target" ];
              Timer = {
                OnCalendar = "*-*-15 05:05:00 America/Chicago";
              };
            };
            "taffersparadise" = {
              Install.WantedBy = [ "timers.target" ];
              Timer = {
                OnCalendar = "*-01,07-01 11:05:00 America/Chicago";
              };
            };
            /*
              "wii_rvz_usa" = {
              Install.WantedBy = [ "timers.target" ];
              Timer = {
                OnCalendar = "*-*-* 6:30:00 America/Chicago";
              };
                };
            */
          };
        };
      };
    };
}
