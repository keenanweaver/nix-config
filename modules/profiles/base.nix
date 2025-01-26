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
    envfs.enable = false; # Currently breaks my systems
    fastfetch.enable = true;
    fd.enable = true;
    fzf.enable = true;
    git.enable = true;
    gpg.enable = true;
    helix.enable = true;
    home-managerConfig.enable = true;
    jujutsu.enable = true;
    keyd.enable = false;
    lazygit.enable = true;
    lsd.enable = true;
    mullvad.enable = true;
    navi.enable = true;
    nh.enable = true;
    nix-ld.enable = true;
    nix-index.enable = true;
    nushell.enable = true;
    nvim.enable = true;
    pay-respects.enable = true;
    ripgrep.enable = true;
    ssh.enable = true;
    starship.enable = true;
    tailscale.enable = true;
    tealdeer.enable = true;
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
    secrets.enable = true;
    users.enable = true;
    virtualization.enable = true;

    console = {
      earlySetup = true;
    };
    environment = {
      homeBinInPath = true;
      localBinInPath = true;
      shells = with pkgs; [
        bashInteractive
        zsh
      ];
      systemPackages = with pkgs; [
        lm_sensors
        pciutils
        sops
        ssh-to-age
        xdg-dbus-proxy
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
      extraConfig = ''
        DefaultTimeoutStartSec=15s
        DefaultTimeoutStopSec=10s
      '';
    };

    system.stateVersion = "23.11";

    time.timeZone = "America/Chicago";

    home-manager.users.${username} =
      { lib, username, ... }:
      {
        # https://github.com/nix-community/home-manager/issues/3849#issuecomment-2115899992
        # Copy dotfiles recursively in home
        home.file =
          let
            listFilesRecursive =
              dir: acc:
              lib.flatten (
                lib.mapAttrsToList (
                  k: v: if v == "regular" then "${acc}${k}" else listFilesRecursive dir "${acc}${k}/"
                ) (builtins.readDir "${dir}/${acc}")
              );

            toHomeFiles =
              dir:
              builtins.listToAttrs (
                map (x: {
                  name = x;
                  value = {
                    source = "${dir}/${x}";
                  };
                }) (listFilesRecursive dir "")
              );
          in
          toHomeFiles ../../dotfiles;
        home = {
          username = username;
          homeDirectory = lib.mkDefault "/home/${username}";
          stateVersion = "23.11";
        };
      };
  };
}
