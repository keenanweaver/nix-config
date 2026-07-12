{
  flake.modules = {
    homeManager.base-profile = {
      programs = {
        delta = {
          options = {
            light = false;
            line-numbers = true;
            navigate = true;
            side-by-side = true;
          };
          enable = true;
          enableGitIntegration = true;
        };
        gh.enable = true;
        git = {
          enable = true;
          settings = {
            diff = {
              colorMoved = "default";
            };
            merge = {
              conflictstyle = "diff3";
            };
            safe = {
              directory = [
                "/mnt/crusader/Projects/Codeberg/nix-config"
                "/mnt/crusader/Projects/Codeberg/nix-config-dendritic"
                "/mnt/crusader/Projects/GitHub/keenanweaver.github.io"
                "/mnt/crusader/Projects/GitHub/nix-config"
                "/mnt/crusader/Projects/Gitlab/moka-pics"
              ];
            };
            user = {
              email = "keenanweaver@protonmail.com";
              name = "Keenan Weaver";
            };
          };
          signing = {
            format = "openpgp";
            signByDefault = true;
          };
        };
      };
    };
    nixos.base-profile = {
      programs.git = {
        enable = true;
      };
    };
  };
}
