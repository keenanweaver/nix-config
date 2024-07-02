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
        keep-outputs = true
        keep-derivations = true
      '';
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
      settings = {
        auto-optimise-store = true;
        connect-timeout = 5;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        log-lines = lib.mkDefault 25;
        substituters = [
          "https://nyx.chaotic.cx"
          "https://cache.nixos.org"
          "https://hyprland.cachix.org"
          "https://nix-gaming.cachix.org"
          "https://nix-community.cachix.org"
          "https://nixpkgs-wayland.cachix.org"
        ];
        trusted-public-keys = [
          "nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        ];
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
        inputs.nur.overlay
        (self: super: { })
        (final: prev: { })
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
      { config, username, ... }:
      {
        home = {
          extraProfileCommands = ''
            export GPG_TTY=$(tty)
          '';
          language.base = "en_US.UTF-8";
          sessionPath = [
            "/home/${username}/.bin"
            "/home/${username}/.local/bin"
            "/var/lib/flatpak/exports/bin"
            "${config.xdg.dataHome}/flatpak/exports/bin"
            "${config.xdg.dataHome}/distrobox/exports/bin"
          ];
          sessionVariables = {
            NIXOS_OZONE_WL = "1";
            NIXPKGS_ALLOW_UNFREE = "1";
            RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
            #WLR_NO_HARDWARE_CURSOR = "1";
            XCOMPOSECACHE = "${config.xdg.cacheHome}/X11/xcompose";
          };
          shellAliases = {
            b = "bat --color=always -pp";
            bb = "bat --color=always";
            #bd = "batdiff";
            #bg = "batgrep";
            #bm = "batman";
            #bp = "batpipe";
            db = "distrobox";
            dbe = "db enter";
            l = "lsd -la --group-dirs=first";
            ls = "lsd -l --group-dirs=first";
            #nn = "nnn -dHix";
            #n = "micro";
            nv = "nvim";
            #nfc = "nix flake check /mnt/crusader/Projects/GitHub/nix-config --no-build";
            ngc = "nh clean all";
            #nhr = "nh home switch";
            nor = "nh os switch";
            npr = "nix run nixpkgs#nixpkgs-review -- pr";
            psr = "plasmashell --replace & disown";
            rbn = "podman stop -a && systemctl reboot";
            repw = "systemctl --user restart wireplumber pipewire pipewire-pulse pipewire-pulse.socket";
            sudo = "sudo ";
            up = "topgrade";
            wget = "wget --hsts-file=${config.xdg.dataHome}/wget-hsts";
            wttr = "curl wttr.in/Omaha\\?format=4";
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
