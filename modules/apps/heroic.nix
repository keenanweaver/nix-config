{
  flake.modules.homeManager.profile-gaming =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ heroic ];
    };
}
