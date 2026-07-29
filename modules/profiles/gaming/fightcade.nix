{
  flake.modules.homeManager.gaming-profile = {
    # fc2jsons come from non-free flake input
    services.flatpak = {
      overrides = {
        "com.fightcade.Fightcade" = {
          Environment = {
            USE_DXVK = "1";
          };
        };
      };

      packages = [
        "com.fightcade.Fightcade"
        "com.fightcade.Fightcade.Wine"
      ];

    };
  };
}
