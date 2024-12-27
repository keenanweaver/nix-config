{
  inputs,
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
        man-db.enable = true;
        generateCaches = true;
      };
    };
    nix = {
      extraOptions = ''
        builders-use-substitutes = true
        keep-outputs = true
        keep-derivations = true
      '';
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
      nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
      optimise = {
        automatic = true;
        dates = [ "10:00" ];
      };
      settings = {
        auto-optimise-store = true;
        connect-timeout = 5;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        extra-substituters = [
          "https://nix-community.cachix.org"
          "https://nyx.chaotic.cx"
        ];
        extra-trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        ];
        log-lines = lib.mkDefault 25;
        trusted-users = [ "${username}" ];
        use-xdg-base-directories = false;
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

    system.autoUpgrade = {
      enable = false;
      dates = "04:00:00";
      allowReboot = if vars.server then true else false;
      rebootWindow = {
        lower = "04:00";
        upper = "06:00";
      };
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
            NIXOS_OZONE_WL = "1"; # Electron apps
            NIXPKGS_ALLOW_UNFREE = "1";
            #RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
            #WLR_NO_HARDWARE_CURSOR = "1";
            XCOMPOSECACHE = "${config.xdg.cacheHome}/X11/xcompose";
          };
          shellAliases = {
            b = "bat --color=always -pp";
            bb = "bat --color=always";
            db = "distrobox";
            dbe = "db enter";
            l = "lsd -la --group-dirs=first";
            ls = "lsd -l --group-dirs=first";
            nv = "nvim";
            ngc = "nh clean all";
            nor = "nh os switch";
            npr = "nix run nixpkgs#nixpkgs-review -- pr";
            psr = "plasmashell --replace & disown";
            rbn = "podman stop -a && systemctl reboot";
            repw = "${lib.optionalString vars.gaming "systemctl --user stop gpu-screen-recorder &&"} systemctl --user restart pipewire{,-pulse} wireplumber ${lib.optionalString vars.gaming "&& systemctl --user start gpu-screen-recorder"}";
            sudo = "sudo ";
            up = "topgrade";
            wget = "wget --hsts-file=${config.xdg.dataHome}/wget-hsts";
          };
        };
        nix = {
          gc = {
            automatic = true;
            frequency = "weekly";
            options = "--delete-older-than 30d";
          };
        };
        xdg = {
          enable = true;
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
