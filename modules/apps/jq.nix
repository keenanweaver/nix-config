{
  flake.modules.homeManager.base-profile = {
    programs.jq = {
      enable = true;
    };
  };
}
