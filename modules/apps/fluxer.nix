{
  flake.modules.homeManager.fluxer =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        fluxer-desktop
      ];
    };
}
