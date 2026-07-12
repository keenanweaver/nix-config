{
  flake.modules.homeManager.base-profile = {
    programs.atuin = {
      enable = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
    };
  };
}
