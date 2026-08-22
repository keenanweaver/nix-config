{
  flake.modules.homeManager.profile-base.programs.lazygit = {
    enable = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
    settings = {
      gui.mouseEvents = false;
      promptToReturnFromSubprocess = false;
    };
  };
}
