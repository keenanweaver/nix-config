{
  flake.modules.homeManager.profile-base.programs.lazygit = {
    enable = true;
    settings = {
      gui.mouseEvents = false;
      promptToReturnFromSubprocess = false;
    };
  };
}
