{
  lib,
  username,
  pkgs,
  ...
}:
{
  imports = [
    # System
    ./disko.nix
    ./hardware-configuration.nix
    ./impermanence.nix
    # Profiles
    ../../modules
  ];

  networking = {
    hostName = "remorse";
    wireless.enable = false;
  };

  services = {
    homearr = {
      enable = true;
    };
    home-assistant = {
      enable = true;
      openFirewall = true;
    };
    netdata = {
      enable = true;
    };
    ntfy-sh = {
      enable = true;
    };
    uptime-kuma = {
      enable = true;
    };
  };

  virtualisation = {
    oci-containers = {
      containers = {
        homarr = {
          image = "ghcr.io/ajnart/homarr:latest";
          ports = [ "7575:7575" ];
          volumes = [
            "./homarr/data:/data"
            "./homarr/configs:/app/data/configs"
            "./homarr/icons:/app/public/icons"
          ];
        };
      };
    };
  };

  home-manager.users.${username} = {

  };
}
