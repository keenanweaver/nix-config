{ self, ... }:
{
  flake.modules.nixos.profile-base =
    {
      lib,
      config,
      ...
    }:
    {
      networking = {
        hosts = lib.mapAttrs' (name: ip: lib.nameValuePair ip [ name ]) self.lib.site.network.hosts;
        networkmanager.enable = true;
        nftables.enable = true;
        wireguard.enable = true;
      };
      preservation.preserveAt."/persist".directories = [
        "/etc/NetworkManager/system-connections"
        "/etc/wireguard"
        "/var/lib/NetworkManager"
      ];
      services = {
        avahi = {
          enable = true;
          nssmdns4 = true;
          openFirewall = true;
          publish = {
            enable = true;
            addresses = true;
            workstation = true;
          };
        };
        resolved.enable = true;
      };
      users.users.${config.my.user}.extraGroups = [
        "networkmanager"
      ];
    };
}
