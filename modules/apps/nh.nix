{ self, ... }:
let
  inherit (self.lib.site) nas;
in
{
  flake.modules.homeManager.profile-base.programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 14d --keep 3 --optimise";
    };
    flake = "${nas.mountRoot}/Projects/Codeberg/nix-config-dendritic";
  };
}
