{
  inputs,
  lib,
  config,
  username,
  pkgs,
  ...
}:
{
  options = {
    apollo = {
      enable = lib.mkEnableOption "Enable Apollo in NixOS";
    };
  };
  config = lib.mkIf config.apollo.enable {
    networking = {
      firewall = {
        allowedUDPPorts = [
          # Moonlight
          5353
          47998
          47999
          48000
          48002
          48010
        ];
        allowedTCPPorts = [
          # Moonlight
          47984
          47989
          48010
        ];
      };
    };

    services.apollo = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
      package = inputs.apollo.packages.${pkgs.system}.default;
      applications = {
        apps = [
          {
            exclude-global-prep-cmd = "false";
            auto-detach = "true";
          }
        ];
      };
    };
    home-manager.users.${username} = { };
  };
}
