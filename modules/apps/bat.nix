{
  flake.modules.homeManager.base-profile = { pkgs, ... }: {
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
