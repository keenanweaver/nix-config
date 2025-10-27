{
  lib,
  config,
  pkgs,
  username,
  vars,
  ...
}:
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
    atuin.enable = true;
    bash.enable = true;
    bat.enable = true;
    boxxy.enable = true;
    btop.enable = true;
    direnv.enable = true;
    distrobox.enable = true;
    fastfetch.enable = true;
    fd.enable = true;
    fzf.enable = true;
    git.enable = true;
    gpg.enable = true;
    helix.enable = true;
    home-managerConfig.enable = true;
    jq.enable = true;
    jujutsu.enable = false;
    keyd.enable = false;
    lazydocker.enable = true;
    lazygit.enable = true;
    lazysql.enable = true;
    lsd.enable = true;
    mullvad.enable = true;
    navi.enable = true;
    nh.enable = true;
    nix-index.enable = true;
    nix-init.enable = true;
    nix-ld.enable = true;
    nushell.enable = true;
    nvim.enable = true;
    pay-respects.enable = true;
    rclone.enable = true;
    ripgrep.enable = true;
    ssh.enable = true;
    starship.enable = true;
    tailscale.enable = true;
    tealdeer.enable = true;
    television.enable = true;
    topgrade.enable = true;
    yazi.enable = true;
    yt-dlp.enable = true;
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
    pipewire.enable = true;
    users.enable = true;
    virtualization.enable = true;

    console = {
      earlySetup = true;
    };
    environment = {
      homeBinInPath = true;
      localBinInPath = true;
      shells = with pkgs; [
        bash
        zsh
      ];
      stub-ld.enable = true;
      systemPackages = with pkgs; [
        lm_sensors
        pciutils
        xdg-user-dirs
      ];
    };

    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_ADDRESS = config.i18n.defaultLocale;
        LC_IDENTIFICATION = config.i18n.defaultLocale;
        LC_MEASUREMENT = config.i18n.defaultLocale;
        LC_MONETARY = config.i18n.defaultLocale;
        LC_NAME = config.i18n.defaultLocale;
        LC_NUMERIC = config.i18n.defaultLocale;
        LC_PAPER = config.i18n.defaultLocale;
        LC_TELEPHONE = config.i18n.defaultLocale;
        LC_TIME = config.i18n.defaultLocale;
      };
    };

    services = {
      cron.enable = true;
      dbus.implementation = "broker";
      earlyoom = {
        enable = true;
        freeMemThreshold = 5;
        enableNotifications = if vars.desktop then true else false;
      };
      fstrim.enable = true;
      journald = {
        extraConfig = ''
          SystemMaxUse=50M
        '';
      };
      logrotate.enable = true;
    };

    systemd = {
      settings.Manager = {
        DefaultTimeoutStartSec = "15s";
        DefaultTimeoutStopSec = "10s";
      };
    };

    system.stateVersion = "23.11";

    time.timeZone = "America/Chicago";

    home-manager.users.${username} =
      { lib, username, ... }:
      {
        home = {
          username = username;
          homeDirectory = lib.mkDefault "/home/${username}";
          stateVersion = "23.11";
        };
      };
  };
}
