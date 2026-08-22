{
  flake.modules.homeManager.profile-base.programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 14d --keep 3 --optimise";
    };
    flake = "/mnt/crusader/Projects/Codeberg/nix-config-dendritic";
  };
}
