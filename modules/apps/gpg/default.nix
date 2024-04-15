{ inputs, home-manager, lib, config, username,  ... }: with lib;
let
  cfg = config.gpg;
in
{
  options = {
    gpg = {
      enable = mkEnableOption "Enable gpg in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
      programs.gpg = {
        enable = true;
        #homedir = "${config.xdg.dataHome}/gnupg";
      };
      services.gpg-agent = with pkgs; {
        enable = true;
        enableExtraSocket = true;
        enableSshSupport = true;
        defaultCacheTtl = 43200; # 12h
        defaultCacheTtlSsh = 43200;
        maxCacheTtl = 86400; # 24h
        maxCacheTtlSsh = 86400;
        pinentryPackage = pinentry-qt;
      };
    };
  };
}
