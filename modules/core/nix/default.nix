{
  lib,
  config,
  username,
  vars,
  ...
}:
let
  cfg = config.nixConfig;
in
{
  options = {
    nixConfig = {
      enable = lib.mkEnableOption "Enable nix in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    documentation = {
      man = {
        generateCaches = true;
      };
    };
    nix = {
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
      optimise = {
        automatic = true;
        dates = [ "10:00" ];
      };
      settings = {
        auto-optimise-store = true;
        builders-use-substitutes = true;
        experimental-features = [
          "flakes"
          "nix-command"
        ];
        extra-substituters = [
          "https://nix-community.cachix.org"
        ];
        extra-trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
        log-lines = lib.mkDefault 50;
        trusted-users = [
          "${username}"
          "@wheel"
        ];
        use-xdg-base-directories = false;
        warn-dirty = false;
      };
    };
    nixpkgs = {
      config = {
        allowBroken = false;
        allowUnfree = true;
      };
      overlays = [
        (import ../../../packages/overlay.nix)
      ];
    };
    system = {
      autoUpgrade = {
        enable = if vars.desktop then false else true;
        allowReboot = if vars.desktop then false else true;
        dates = "04:00:00";
        rebootWindow = {
          lower = "04:00";
          upper = "06:00";
        };
      };
    };

    home-manager.users.${username} =
      { config, pkgs, ... }:
      {
        home = {
          extraProfileCommands = ''
            export GPG_TTY=$(tty)
          '';
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
        };
        nixpkgs = {
          config = {
            allowBroken = false;
            allowUnfree = true;
          };
          overlays = [
            (import ../../../packages/overlay.nix)
          ];
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
