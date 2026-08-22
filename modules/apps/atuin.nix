{
  flake.modules.homeManager.profile-base.programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
  };
}
