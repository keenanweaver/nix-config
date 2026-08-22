{
  flake.modules.homeManager.profile-base.programs.tealdeer = {
    enable = true;
    settings.display = {
      compact = false;
      use_pager = false;
    };
  };
}
