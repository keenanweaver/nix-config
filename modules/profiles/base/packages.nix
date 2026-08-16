{ config, ... }:
let
  inherit (config.flake.lib) packageListText;
in
{
  flake.modules = {
    homeManager.base-profile =
      { config, pkgs, ... }:
      {
        home = {
          file.current-packages = {
            enable = true;
            target = "${config.xdg.configHome}/packages-hm";
            text = packageListText pkgs config.home.packages;
          };

          packages = with pkgs; [
            ## System ##
            (_7zz.override { enableUnfree = true; })
            aspell
            aspellDicts.en
            killall
            kmon
            libnotify
            repgrep
            unrar
            unzip
            usbutils
            viu
            wget
            zip
          ];
        };
      };

    nixos.base-profile =
      { config, pkgs, ... }:
      {
        environment = {
          etc."packages".text = packageListText pkgs config.environment.systemPackages;

          systemPackages = with pkgs; [
            lm_sensors
            pciutils
            xdg-user-dirs
          ];
        };
      };
  };
}
