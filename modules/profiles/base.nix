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

    documentation = {
      man = {
        generateCaches = true;
      };
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
      {
        config,
        lib,
        username,
        ...
      }:
      {
        home = {
          extraProfileCommands = ''
            export GPG_TTY=$(tty)
          '';
          homeDirectory = lib.mkDefault "/home/${username}";
          language.base = "en_US.UTF-8";
          sessionPath = [
            "${config.home.homeDirectory}/.bin"
            "${config.home.homeDirectory}/.local/bin"
          ];
          sessionVariables = {
            NIXOS_OZONE_WL = "1"; # Electron apps
            NIXPKGS_ALLOW_UNFREE = "1";
            XCOMPOSECACHE = "${config.xdg.cacheHome}/X11/xcompose";
          };
          shellAliases = {
            b = "${lib.getExe pkgs.bat} --color=always -pp";
            bb = "${lib.getExe pkgs.bat} --color=always";
            db = lib.getExe' config.programs.distrobox.package "distrobox";
            dbe = "db enter";
            imp = "${lib.getExe config.programs.fd.package} --one-file-system --base-directory / -t f -H -E '{tmp,etc/passwd,var/lib/systemd/coredump}'"; # https://reddit.com/r/NixOS/comments/1nhm4mm/tailscale_impermanence_broken/nedm0vd/?context=3#nedm0vd
            l = "${lib.getExe config.programs.lsd.package} -la --group-dirs=first";
            nv = lib.getExe' config.programs.nvf.settings.vim.package "neovim";
            ngc = "${lib.getExe config.programs.nh.package} clean all";
            nor = "${lib.getExe config.programs.nh.package} os switch";
            npr = "${lib.getExe pkgs.nixpkgs-review} pr --print-result";
            psr = "plasmashell --replace & disown";
            rbn = "podman stop -a && systemctl reboot";
            repw = "systemctl --user restart pipewire{,-pulse} wireplumber";
            upd = lib.getExe pkgs.topgrade;
            wget = "${lib.getExe pkgs.wget} --hsts-file=${config.xdg.dataHome}/wget-hsts";
          };
          username = username;
          stateVersion = "23.11";
        };
        xdg = {
          enable = true;
          autostart.enable = true;
          userDirs = {
            enable = true;
            createDirectories = true;
            templates = null;
            publicShare = null;
          };
        };
      };
  };
}
