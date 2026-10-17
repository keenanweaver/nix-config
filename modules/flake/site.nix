let
  nasMountRoot = "/mnt/crusader";
in
{
  site = {
    location = {
      latitude = 41.12;
      longitude = -95.91;
    };
    nas = {
      host = "crusader";
      mountRoot = nasMountRoot;
      paths = {
        gogBackups = "${nasMountRoot}/Games/Backups/GOG";
        halfLife = "${nasMountRoot}/Games/Games/Half-Life";
        idgames = "${nasMountRoot}/Games/Games/Doom/idgames";
        thiefFanMissions = "${nasMountRoot}/Games/Games/Thief/Fan Missions";
      };
    };
    network = {
      gateway = "10.20.20.1";
      hosts = {
        MiSTer = "10.20.20.29";
        UCK-G2 = "10.20.1.7";
        bazzite = "10.20.20.11";
        crusader = "10.20.20.13";
        maniac = "10.20.20.33";
        nixos-desktop = "10.20.20.5";
        nixos-htpc = "10.20.20.15";
        nixos-laptop = "10.20.20.20";
        opnsense = "10.20.1.1";
        regret = "10.20.20.31";
        remorse = "10.20.20.30";
        vagabond = "10.20.20.32";
      };
      lanSubnet = "10.20.20.0/24";
      sshPort = 6777;
    };
    services.ntfy = "regret";
  };
}
