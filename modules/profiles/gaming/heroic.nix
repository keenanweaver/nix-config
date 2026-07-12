{
  flake.modules.homeManager.gaming-profile = { pkgs, ... }: {
    home.packages = with pkgs; [ heroic ];
  };
}
