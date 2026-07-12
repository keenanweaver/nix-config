{
  flake.modules.homeManager.base-profile = {
    programs.nix-init = {
      enable = true;
    };
  };
}
