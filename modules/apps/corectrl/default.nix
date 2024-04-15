{ inputs, home-manager, lib, config, username, ... }: with lib;
let
  cfg = config.corectrl;
in
{
  options = {
    corectrl = {
      enable = mkEnableOption "Enable corectrl in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    programs = {
      corectrl = {
        enable = true;
        gpuOverclock.enable = true;
        gpuOverclock.ppfeaturemask = "0xffffffff";
      };
    };
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
      home.file = {
        desktop-entry-corectrl = {
          enable = true;
          recursive = false;
          text = ''
            [Desktop Entry]
            Categories=System;Settings;Utility;
            Comment=Control your computer with ease using application profiles
            Exec=corectrl
            GenericName=Core control
            Icon=corectrl
            Keywords=core;control;system;hardware;
            Name=CoreCtrl
            StartupNotify=true
            StartupWMClass=corectrl
            Terminal=false
            Type=Application
          '';
          target = "${config.xdg.configHome}/autostart/org.corectrl.corectrl.desktop";
        };
      };
    };
  };
}
