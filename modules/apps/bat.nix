{
  flake.modules.homeManager.profile-base =
    { pkgs, ... }:
    {
      programs.bat = {
        enable = true;
        extraPackages = with pkgs.bat-extras; [
          batdiff
          batgrep
          batman
          batpipe
        ];
      };
    };
}
