{
  flake.modules.homeManager.plasma-manager.programs.okular = {
    enable = true;
    general = {
      obeyDrm = false;
      openFileInTabs = true;
      showScrollbars = true;
      smoothScrolling = true;
      viewMode = "Facing";
      zoomMode = "fitWidth";
    };
    performance.enableTransparencyEffects = true;
  };
}
