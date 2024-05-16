{
  lib,
  config,
  username,
  dotfiles,
  ...
}:
let
  cfg = config.mangohud;
in
{
  options = {
    mangohud = {
      enable = lib.mkEnableOption "Enable mangohud in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} =
      { config, pkgs, ... }:
      {
        home.file = {
          desktop-entry-mangohud-get-vars = {
            enable = true;
            text = ''
              [Desktop Entry]
              Exec=${config.xdg.configHome}/MangoHud/get-vars.sh
              Icon=dialog-scripts
              Name=get-vars.sh
              Type=Application
              X-KDE-AutostartScript=true
            '';
            target = "${config.xdg.configHome}/autostart/get-vars.desktop";
          };
          /*
            mangohud = {
                     enable = true;
                     source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/MangoHud/MangoHud.conf";
                     target = "${config.xdg.configHome}/MangoHud/MangoHud.conf";
                   };
          */
          script-mangohud-get-vars = {
            enable = true;
            text = ''
              #!/usr/bin/env bash
              # OS
              grep -w PRETTY_NAME /etc/os-release | cut -d '=' -f2 | tr -d '"' > ${config.xdg.configHome}/MangoHud/vars
              # Kernel
              echo $(uname -r) >> ${config.xdg.configHome}/MangoHud/vars
              # CPU
              lscpu | grep -oP '(?<=Model\sname:).*' | xargs >> ${config.xdg.configHome}/MangoHud/vars
              # GPU
              glxinfo | grep -oP '(?<=Device: )(.*?)(?=\()' >> ${config.xdg.configHome}/MangoHud/vars
            '';
            target = "${config.xdg.configHome}/MangoHud/get-vars.sh";
            executable = true;
          };
        };
        programs.mangohud = {
          enable = true;
          package = pkgs.mangohud_git; # Chaotic package
        };
      };
  };
}
