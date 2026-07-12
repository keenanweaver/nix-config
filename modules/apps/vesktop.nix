{
  flake.modules.homeManager.vesktop = { pkgs, ... }: {
    programs.vesktop = {
      enable = true;
      package = pkgs.vesktop.override { withMiddleClickScroll = true; };
    };
  };
}
