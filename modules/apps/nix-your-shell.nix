{
  flake.modules.homeManager.base-profile.programs.nix-your-shell = {
    enable = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
    nix-output-monitor.enable = true;
  };
}
