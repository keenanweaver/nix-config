{
  config,
  inputs,
  lib,
  pkgs,
  username,
  ...
}:
let
  cfg = config.hyprland;
in
{

  options = {
    hyprland = {
      enable = lib.mkEnableOption "Enable hyprland in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    environment = {
      sessionVariables = {
        NIXOS_OZONE_WL = "1"; # hint electron apps to use wayland
        MOZ_ENABLE_WAYLAND = "1"; # ensure enable wayland for Firefox
        WLR_RENDERER_ALLOW_SOFTWARE = "1"; # enable software rendering for wlroots
        WLR_NO_HARDWARE_CURSORS = "1"; # disable hardware cursors for wlroots
        NIXOS_XDG_OPEN_USE_PORTAL = "1"; # needed to open apps after web login
      };
    };

    programs = {
      hyprland = {
        enable = true;
      };
      xfconf.enable = true;
      file-roller.enable = true;
    };
    services = {
      displayManager = {
        autoLogin = {
          user = "${username}";
        };
        sddm = {
          enable = true;
          settings = {
            General = {
              InputMethod = ""; # Remove virtual keyboard
            };
          };
          wayland = {
            enable = true;
          };
        };
      };
      gnome.gnome-keyring.enable = true;
      gvfs.enable = true; # Mount, trash, and other functionalities
      tumbler.enable = true; # Thumbnail support for images
    };
    xdg = {
      portal = {
        config.common.default = "*";
        extraPortals = with pkgs; [
          kdePackages.xdg-desktop-portal-kde
          xdg-desktop-portal-gtk
        ];
        xdgOpenUsePortal = true;
      };
    };
    home-manager.users.${username} = {
      home = {
        packages = with pkgs; [
          # utilities
          rofi-wayland
          swaybg
          networkmanagerapplet
          blueman # bluetooth
          pavucontrol # audio
          playerctl
          wlogout
          imv # image viewer

          # KDE apps
          kdePackages.kate
        ];
      };
      programs = {
        hyprlock = {
          enable = true;
          settings = {
            general = {
              disable_loading_bar = true;
              grace = 30;
              hide_cursor = true;
              no_fade_in = false;
            };

            background = [
              {
                path = "screenshot";
                blur_passes = 3;
                blur_size = 8;
              }
            ];

            input-field = [
              {
                size = "200, 50";
                position = "0, -80";
                monitor = "";
                dots_center = true;
                fade_on_empty = false;
                font_color = "rgb(202, 211, 245)";
                inner_color = "rgb(91, 96, 120)";
                outer_color = "rgb(24, 25, 38)";
                outline_thickness = 5;
                placeholder_text = "Rara...";
                shadow_passes = 2;
              }
            ];
          };
        };
        waybar = {
          enable = true;
          settings = [
            {
              layer = "top";
              position = "top";
              margin-left = 12;
              margin-right = 12;
              margin-top = 5;
              spacing = 1;

              modules-left = [
                "custom/power"
                "hyprland/workspaces"
              ];
              modules-center = [ "clock" ];
              modules-right = [
                "cpu"
                "memory"
                "disk"
                "pulseaudio"
                "tray"
              ];

              "hyprland/workspaces" = {
                on-click = "activate";
                # https://github.com/Alexays/Waybar/wiki/Module:-Workspaces#persistent-workspaces
                persistent-workspaces = {
                  "1" = [ ];
                  "2" = [ ];
                  "3" = [ ];
                  "4" = [ ];
                  "5" = [ ];
                  "6" = [ ];
                };
                format = "{icon}";
                format-icons = {
                  "1" = "󰹈";
                  "2" = "";
                  "3" = "";
                  "4" = "󰭹";
                  "5" = "󰺵";
                  "6" = "󰻈";
                };
              };

              tray = {
                icon-size = 18;
                spacing = 5;
                show-passive-items = true;
              };

              clock = {
                interval = 60;
                format = "  {:%a %b %d <b>%H:%M</b>}";
                exec-on-event = "true";
                on-click = "merkuro";
              };

              cpu = {
                interval = 2;
                format = "  {usage}%";
                tooltip = false;
              };

              memory = {
                interval = 2;
                format = "  {}%";
              };

              disk = {
                interval = 15;
                format = "󰋊 {percentage_used}%";
                exec-on-event = "true";
                on-click = "swaync-client -t -sw";
              };

              pulseaudio = {
                format = "{icon}  {volume}%";
                format-bluetooth = "{icon}  {volume}% 󰂯";
                format-bluetooth-muted = "󰖁 {icon} 󰂯";
                format-muted = "󰖁 {format_source}";
                format-source = "{volume}% ";
                format-source-muted = "";
                format-icons = {
                  headphone = "󰋋";
                  hands-free = "󱡒";
                  headset = "󰋎";
                  phone = "";
                  portable = "";
                  car = "";
                  default = [
                    ""
                    ""
                    ""
                  ];
                };
                on-click = "pavucontrol";
              };
              "custom/power" = {
                format = "{icon}";
                format-icons = "";
              };
              "custom/sepp" = {
                format = "|";
              };
            }
          ];
          systemd.enable = true;
        };
      };
      services.kdeconnect = {
        enable = true;
        package = pkgs.kdePackages.kdeconnect-kde;
      };
      wayland.windowManager.hyprland = {
        enable = true;
        systemd = {
          enableXdgAutostart = true;
        };
        settings = {

        };
      };
    };
  };
}
