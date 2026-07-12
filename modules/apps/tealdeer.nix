{
  flake.modules.homeManager.base-profile = {
    programs.tealdeer = {
      enable = true;
      settings = {
        display = {
          compact = false;
          use_pager = false;
        };
      };
    };
  };
}
