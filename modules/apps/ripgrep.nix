{
  flake.modules.homeManager.profile-base.programs.ripgrep = {
    enable = true;
    arguments = [ "-uuu" ];
  };
}
