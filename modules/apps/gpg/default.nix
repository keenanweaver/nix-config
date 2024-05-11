{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.gpg;
in
{
  options = {
    gpg = {
      enable = lib.mkEnableOption "Enable gpg in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} =
      { pkgs, ... }:
      {
        programs.gpg = {
          enable = true;
        };
        services.gpg-agent = {
          enable = true;
          enableExtraSocket = true;
          enableSshSupport = true;
          defaultCacheTtl = 43200; # 12h
          defaultCacheTtlSsh = 43200;
          maxCacheTtl = 86400; # 24h
          maxCacheTtlSsh = 86400;
          pinentryPackage = pkgs.pinentry-qt;
        };
      };
  };
}
