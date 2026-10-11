{ self, ... }:
{
  flake.modules.homeManager.profile-base =
    {
      config,
      pkgs,
      osConfig,
      ...
    }:
    let
      inherit (self.lib.site.nas) mountRoot;
      email = "keenanweaver@protonmail.com";
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
            gpg.ssh.allowedSignersFile = "${pkgs.runCommand "git-allowed-signers" { } ''
              awk 'NF { print "${email}", $0 }' ${osConfig.my.sshKeys} > $out
            ''}";
            merge.conflictstyle = "diff3";
            safe.directory = [
              "${mountRoot}/Projects/Codeberg/nix-config-dendritic"
              "${mountRoot}/Projects/GitHub/keenanweaver.github.io"
              "${mountRoot}/Projects/Gitlab/moka-pics"
            ];
            user = {
              inherit email;
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
