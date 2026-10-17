{ config, ... }:
let
  inherit (config) site;
in
{
  flake.modules.nixos = {
    profile-base =
      { lib, ... }:
      {
        networking = {
          hosts = lib.mapAttrs' (name: ip: lib.nameValuePair ip [ name ]) site.network.hosts;
          nftables.enable = true;
        };
        services = {
          avahi = {
            enable = true;
            nssmdns4 = true;
            publish = {
              enable = lib.mkDefault true;
              addresses = true;
              workstation = true;
            };
          };
          resolved = {
            enable = true;
            settings.Resolve.LLMNR = "false";
          };
        };
      };
    profile-desktop =
      { config, ... }:
      {
        networking.networkmanager.enable = true;
        preservation.preserveAt."/persist".directories = [
          "/etc/NetworkManager/system-connections"
          "/var/lib/NetworkManager"
        ];
        users.users.${config.my.user}.extraGroups = [
          "networkmanager"
        ];
      };
  };
}
