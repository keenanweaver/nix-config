{
  flake.modules.homeManager.profile-base.programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    silent = true;
  };
}
