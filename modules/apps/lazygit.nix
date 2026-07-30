{
  flake.modules.homeManager.base-profile = {
    programs.lazygit = {
      enable = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
      settings = {
        gui.mouseEvents = false;
        promptToReturnFromSubprocess = false;
      };
    };
  };
}
