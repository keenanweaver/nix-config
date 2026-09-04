{ config, ... }:
let
  inherit (config.flake.lib) packageListText;
in
{
  flake.modules = {
    homeManager.profile-base =
      { config, pkgs, ... }:
      {
        home = {
          file.current-packages = {
            enable = true;
            target = "${config.xdg.configHome}/packages-hm";
            text = packageListText pkgs config.home.packages;
          };
          packages = with pkgs; [
            (_7zz.override { enableUnfree = true; })
            aspell
            aspellDicts.en
            killall
            kmon
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
    nixos.profile-base =
      { config, pkgs, ... }:
      {
        environment.etc."packages".text = packageListText pkgs config.environment.systemPackages;
      };
  };
}
