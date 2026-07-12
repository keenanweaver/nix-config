{
  flake.modules.homeManager.base-profile = {
    programs.devenv = {
      enable = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
    };
  };
}
