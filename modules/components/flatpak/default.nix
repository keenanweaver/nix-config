{
  lib,
  config,
  username,
  dotfiles,
  pkgs,
  vars,
  ...
}:
let
  cfg = config.flatpak;
in
{
  imports = [ ./flatpak-fix.nix ];

  options = {
    flatpak = {
      enable = lib.mkEnableOption "Enable flatpak in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    services.flatpak.enable = true;
    /*
      systemd.services.flatpak-repo = {
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.flatpak ];
        script = ''
          flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
          flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        '';
      };
    */
    environment.systemPackages = with pkgs; [ flatpak-builder ];

    users.users.${username}.extraGroups = [ "flatpak" ];

    xdg.portal.enable = true;

    home-manager.users.${username} =
      { config, username, ... }:
      {
        home.file = {
          /*
              flatpak-list = {
                       enable = true;
                       source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/flatpak";
                       target = ".local/bin/.flatpak-list";
                     };
                     flatpak-list-beta = {
                       enable = true;
                       source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/flatpak-beta";
                       target = ".local/bin/.flatpak-list-beta";
                     };
                     flatpak-list-games = {
                       enable = vars.gaming;
                       source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/flatpak-games";
                       target = ".local/bin/.flatpak-games-list";
                     };
                     flatpak-list-sys = {
                       enable = true;
                       source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/flatpak-sys";
                       target = ".local/bin/.flatpak-list-sys";
                     };

            flatpak-overrides = {
              enable = true;
              recursive = true;
              source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.local/share/flatpak/overrides";
              target = "${config.xdg.dataHome}/flatpak/overrides";
            };
          */
          flatpak-overrides-global = {
            enable = true;
            text = ''
              [Context]
              filesystems=/run/media/${username}:ro;/home/${username}/.icons:ro;/home/${username}/.themes:ro;xdg-data/themes:ro;xdg-data/icons:ro;xdg-config/gtkrc:ro;xdg-config/gtkrc-2.0:ro;xdg-config/gtk-2.0:ro;xdg-config/gtk-3.0:ro;xdg-config/gtk-4.0:ro;xdg-run/.flatpak/com.xyz.armcord.ArmCord:create;xdg-run/discord-ipc-*;xdg-config/MangoHud:ro;/nix/store:ro
            '';
            target = "${config.xdg.dataHome}/flatpak/overrides/global";
          };
          script-flatpak-install-all = {
            enable = true;
            text = ''
              #!/usr/bin/env bash
              /home/${username}/.local/bin/flatpak-install-sys.sh
              /home/${username}/.local/bin/flatpak-install.sh
              /home/${username}/.local/bin/flatpak-install-games.sh
            '';
            target = ".local/bin/flatpak-install-all.sh";
            executable = true;
          };
          script-flatpak-install = {
            enable = true;
            text = ''
              #!/usr/bin/env bash
              < /home/${username}/.local/bin/.flatpak-list xargs flatpak install --user --assumeyes
            '';
            target = ".local/bin/flatpak-install.sh";
            executable = true;
          };
          script-flatpak-install-games = {
            enable = vars.gaming;
            text = ''
              #!/usr/bin/env bash
              < /home/${username}/.local/bin/.flatpak-games-list xargs flatpak install --user --assumeyes
            '';
            target = ".local/bin/flatpak-install-games.sh";
            executable = true;
          };
          script-flatpak-install-beta = {
            enable = true;
            text = ''
              #!/usr/bin/env bash
              < /home/${username}/.local/bin/.flatpak-list-beta xargs flatpak install --user --assumeyes
            '';
            target = ".local/bin/flatpak-install-beta.sh";
            executable = true;
          };
          script-flatpak-install-sys = {
            enable = true;
            text = ''
              #!/usr/bin/env bash
              < /home/${username}/.local/bin/.flatpak-list-sys xargs flatpak install --system --assumeyes
            '';
            target = ".local/bin/flatpak-install-sys.sh";
            executable = true;
          };
        };
      };
  };
}
