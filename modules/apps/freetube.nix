{
  flake.modules.homeManager.profile-workstation.programs.freetube = {
    enable = true;
    settings = {
      allowDashAv1Formats = true;
      checkForUpdates = false;
      defaultQuality = "1080";
      defaultViewingMode = "theatre";
      useSponsorBlock = true;
    };
  };
}
