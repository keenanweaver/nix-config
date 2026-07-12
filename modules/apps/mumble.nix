{
  flake.modules.homeManager.mumble = { pkgs, ... }: {
    home.packages = with pkgs; [ mumble ];
  };
}
