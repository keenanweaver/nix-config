{
  flake.modules.homeManager.profile-desktop =
    {
      lib,
      config,
      pkgs,
      osConfig,
      ...
    }:
    {
      home = lib.mkIf config.programs.distrobox.enable {
        packages = with pkgs; [
          distrobox-tui
          kontainer
        ];
        shellAliases = {
          db = "distrobox";
          dbe = "db enter";
        };
      };
      programs.distrobox.enable = lib.mkDefault osConfig.virtualisation.podman.enable;
    };
}
