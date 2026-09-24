{
  flake.modules.homeManager = {
    profile-base =
      {
        lib,
        config,
        pkgs,
        osConfig,
        ...
      }:
      {
        home.packages = lib.optionals config.programs.distrobox.enable [ pkgs.distrobox-tui ];
        programs.distrobox.enable = lib.mkDefault osConfig.virtualisation.podman.enable;
      };
    profile-desktop =
      {
        lib,
        config,
        pkgs,
        ...
      }:
      {
        home = lib.mkIf config.programs.distrobox.enable {
          packages = [ pkgs.kontainer ];
          shellAliases = {
            db = "distrobox";
            dbe = "db enter";
          };
        };
      };
  };
}
