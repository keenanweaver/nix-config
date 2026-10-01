{
  flake.modules.homeManager.profile-base.programs.nix-your-shell = {
    enable = true;
    nix-output-monitor.enable = true;
  };
}
