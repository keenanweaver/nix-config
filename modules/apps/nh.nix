{
  flake.modules.homeManager.base-profile = {
    programs.nh = {
      flake = "/mnt/crusader/Projects/Codeberg/nix-config-dendritic";

      clean = {
        enable = true;
        extraArgs = "--keep-since 14d --keep 3 --optimise";
      };

      enable = true;
    };
  };
}
