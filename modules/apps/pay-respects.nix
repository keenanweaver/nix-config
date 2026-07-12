{
  flake.modules.homeManager.base-profile = {
    programs.pay-respects = {
      enable = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
    };
  };
}
