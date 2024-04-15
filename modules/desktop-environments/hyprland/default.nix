{ inputs, home-manager, lib, config, pkgs, username, ... }: with lib;
let
  cfg = config.hyprland;
  theme_name = "mocha";
in
{
  options = {
    hyprland = {
      enable = mkEnableOption "Enable hyprland in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    #imports = [ inputs.hyprlock.homeManagerModules.default ];

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    };
    services.xserver.displayManager.sddm.enable = true;
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
      home.file = {
        hyprlock-config = {
          enable = true;
          recursive = false;
          source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/hyprland/hyprlock.conf";
          target = "${config.xdg.configHome}/hyprland/hyprlock.conf";
        };
      };
      home.packages = with pkgs; [
        inputs.hyprpaper.packages.${pkgs.system}.hyprpaper
        inputs.hyprpicker.packages.${pkgs.system}.hyprpicker
        # screen capturing
        grim
        slurp
        imagemagick
        swappy

        # clipboard
        wl-clipboard

        # brightness control
        brightnessctl
      ];

      programs = {
        #hyprlock.enable = true;
        waybar.enable = true;
      };

      # enable qt
      qt = {
        enable = true;

        # qt platform theme
        platformTheme = "qt";

        # qt style
        style = {
          name = "adwaita-dark";
          package = pkgs.adwaita-qt;
        };
      };

      wayland.windowManager.hyprland = {
        enable = true;
        package = inputs.hyprland.packages."${pkgs.system}".hyprland;
        enableNvidiaPatches = mkIf config.nvidia;
        #extraConfig = builtins.readFile ./hyprland.conf;
        plugins = [ ];
        settings = {
          source = [
            "${config.xdg.configHome}/hypr/themes/${theme_name}.conf"
          ];
          monitor = [
            "DP-2, 2560x1440, 2560x0, 1" # Primary screen
            "DP-4, 2560x1440, 0x0, 1" # Secondary screen
          ];
          decorations = [

          ];
        };
      };
    };
  };
}
