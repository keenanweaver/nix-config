{
  flake.modules.homeManager.base-profile = {
    programs.ripgrep = {
      enable = true;
      arguments = [ "-uuu" ];
    };
  };
}
