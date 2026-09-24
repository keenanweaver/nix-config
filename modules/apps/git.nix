{
  flake.modules.homeManager.profile-base =
    {
      self,
      config,
      osConfig,
      ...
    }:
    let
      inherit (self.lib.site.nas) mountRoot;
    in
    {
      programs = {
        delta = {
          enable = true;
          enableGitIntegration = true;
          options = {
            light = false;
            line-numbers = true;
            navigate = true;
            side-by-side = true;
          };
        };
        gh.enable = true;
        git = {
          enable = true;
          settings = {
            diff.colorMoved = "default";
            merge.conflictstyle = "diff3";
            safe.directory = [
              "${mountRoot}/Projects/Codeberg/nix-config-dendritic"
              "${mountRoot}/Projects/GitHub/keenanweaver.github.io"
              "${mountRoot}/Projects/Gitlab/moka-pics"
            ];
            user = {
              email = "keenanweaver@protonmail.com";
              name = "Keenan Weaver";
            };
          };
          signing = {
            format = "ssh";
            key = osConfig.sops.secrets."users/${config.home.username}/ssh/id_ed25519".path;
            signByDefault = true;
          };
        };
      };
    };
}
