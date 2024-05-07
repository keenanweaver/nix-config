{ lib, config, pkgs, username, ... }:
let
  cfg = config.base;
in
{
  options = {
    base = {
      enable = lib.mkEnableOption "Enable base in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {
    # Custom modules
    # Apps
    alacritty.enable = true;
    atuin.enable = true;
    bash.enable = true;
    bat.enable = true;
    boxxy.enable = true;
    btop.enable = true;
    direnv.enable = true;
    distrobox.enable = true;
    envfs.enable = true;
    foot.enable = true;
    fzf.enable = true;
    git.enable = true;
    gpg.enable = true;
    helix.enable = true;
    home-managerConfig.enable = true;
    jq.enable = true;
    lazygit.enable = true;
    lsd.enable = true;
    micro.enable = true;
    mullvad.enable = true;
    navi.enable = true;
    nh.enable = true;
    nix-ld.enable = true;
    nix-index.enable = true;
    nnn.enable = true;
    nushell.enable = true;
    nvim.enable = true;
    ripgrep.enable = true;
    ssh.enable = true;
    starship.enable = true;
    tealdeer.enable = true;
    topgrade.enable = true;
    yazi.enable = true;
    yt-dlp.enable = true;
    zellij.enable = false;
    zoxide.enable = true;
    zsh.enable = true;

    # System
    flatpak.enable = true;
    fonts.enable = true;
    hardening.enable = true;
    mounts.enable = true;
    networking.enable = true;
    nixConfig.enable = true;
    packages.enable = true;
    performance.enable = true;
    pipewire.enable = true;
    printing.enable = true;
    secrets.enable = true;
    virtualization.enable = true;
    users.enable = true;

    console = {
      earlySetup = true;
    };
    environment = {
      homeBinInPath = true;
      localBinInPath = true;
      shells = with pkgs; [ bashInteractive zsh ];
      systemPackages = with pkgs; [
        cifs-utils
        nfs-utils
        pciutils
        sops
        ssh-to-age
        xdg-dbus-proxy
        xdg-user-dirs
      ];
    };
    /*     i18n =
      let
        defaultLocale = "en_US.UTF-8";
      in
      {
        extraLocaleSettings = {
          LANG = defaultLocale;
          LC_COLLATE = defaultLocale;
          LC_CTYPE = defaultLocale;
          LC_MESSAGES = defaultLocale;

          LC_ADDRESS = defaultLocale;
          LC_IDENTIFICATION = defaultLocale;
          LC_MEASUREMENT = defaultLocale;
          LC_MONETARY = defaultLocale;
          LC_NAME = defaultLocale;
          LC_NUMERIC = defaultLocale;
          LC_PAPER = defaultLocale;
          LC_TELEPHONE = defaultLocale;
          LC_TIME = defaultLocale;
        };
      }; */

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    services = {
      btrfs.autoScrub.enable = true;
      cron.enable = true;
      dbus.implementation = "broker";
      earlyoom.enable = true;
      fstrim.enable = true;
      logrotate.enable = true;
    };

    system.stateVersion = "23.11";

    time.timeZone = "America/Chicago";

    home-manager.users.${username} = { lib, username, ... }: {
      home = {
        file = {
          script-7z-to-zip = {
            enable = true;
            text = ''
              #!/usr/bin/env bash
              TMPDIR=tempdir_$$
              for x in *.7z; do
                mkdir $TMPDIR
                cd $TMPDIR || return
                cp "../$x" .
                7z x "$x"
                zip -r -9 "../$\\{x%.7z\\}.zip" ./* --exclude ./*.7z
                cd ..
                rm -rf $TMPDIR
              done
            '';
            target = ".local/bin/7z-to-zip.sh";
            executable = true;
          };
        };
        username = username;
        homeDirectory = lib.mkDefault "/home/${username}";
      };
    };
  };
}
