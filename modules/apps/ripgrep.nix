{
  flake.modules.homeManager.base-profile = {
    programs.ripgrep = {
      arguments = [ "-uuu" ];
      enable = true;
    };
  };
}
