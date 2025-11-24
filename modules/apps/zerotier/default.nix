{
  lib,
  config,
  ...
}:
let
  cfg = config.zerotier;
  adapter = "zt6ntckupu";
  networks = [
    "363c67c55a4294ae" # Vagabond Gaming Network
  ];
in
{
  options.zerotier = {
    enable = lib.mkEnableOption "ZeroTier networking";
  };

  config = lib.mkIf cfg.enable {
    # https://github.com/gomaaz/Zerotier_Gaming_Fix#-considerations-for-gaming-with-linux-and-mac-friends
    # https://discuss.zerotier.com/t/lan-game-server-not-visible-through-zerotier-local-lan-works/12166/7
    networking.interfaces.${adapter}.ipv4.routes = [
      {
        address = "255.255.255.255";
        prefixLength = 32;
        options.dev = adapter;
      }
    ];

    services.zerotierone = {
      enable = true;
      joinNetworks = networks;
      localConf = {
        concurrency = 32; # TODO: Better way to make this dynamic & reproducible
        cpuPinningEnabled = true;
        multicoreEnabled = true;
      };
    };

    # Fix long boot times by adjusting service dependencies
    /*
      systemd.services = {
         "network-addresses-${adapter}" = {
           before = lib.mkForce [ ];
           wantedBy = lib.mkForce [
             "network-link-${adapter}.service"
             "zerotierone.service"
             "multi-user.target"
           ];
         };
         "network-link-${adapter}" = {
           before = lib.mkForce [ ];
           wantedBy = lib.mkForce [ "multi-user.target" ];
         };
       };
    */
  };
}
