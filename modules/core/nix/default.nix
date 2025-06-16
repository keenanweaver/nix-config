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
        keep-derivations = true;
        keep-outputs = true;
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
      rebuild.enableNg = true;
      switch.enableNg = true;
    };

    home-manager.users.${username} =
      { config, ... }:
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
            MANPAGER = "batman";
            NIXOS_OZONE_WL = "1"; # Electron apps
            NIXPKGS_ALLOW_UNFREE = "1";
            XCOMPOSECACHE = "${config.xdg.cacheHome}/X11/xcompose";
          };
          shellAliases = {
            b = "bat --color=always -pp";
            bb = "bat --color=always";
            db = "distrobox";
            dbe = "db enter";
            l = "lsd -la --group-dirs=first";
            nv = "nvim";
            ngc = "nh clean all";
            nor = "nh os switch";
            npr = "nixpkgs-review pr --print-result";
            psr = "plasmashell --replace & disown";
            rbn = "podman stop -a && systemctl reboot";
            repw = "systemctl --user restart pipewire{,-pulse} wireplumber";
            up = "topgrade";
            wget = "wget --hsts-file=${config.xdg.dataHome}/wget-hsts";
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
