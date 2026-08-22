{
  flake.modules.homeManager.profile-base.programs.devenv = {
    enable = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
  };
}
