{
  flake.modules.homeManager.profile-workstation =
    { pkgs, ... }:
    {
      programs.vesktop = {
        enable = true;
        package = pkgs.vesktop.override { withMiddleClickScroll = true; };
      };
    };
}
