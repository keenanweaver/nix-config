{
  flake.modules.homeManager.profile-base.programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
  };
}
