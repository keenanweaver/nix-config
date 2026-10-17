{ config, ... }:
let
  inherit (config.site.nas) mountRoot;
in
{
  flake.modules.homeManager = {
    profile-base =
      { pkgs, osConfig, ... }:
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
                awk 'NF { print "${osConfig.my.email}", $0 }' ${osConfig.my.sshKeys} > $out
              ''}";
              merge.conflictstyle = "diff3";
              safe.directory = [
                "${mountRoot}/Projects/Codeberg/nix-config-dendritic"
                "${mountRoot}/Projects/GitHub/keenanweaver.github.io"
                "${mountRoot}/Projects/Gitlab/moka-pics"
              ];
              user = {
                inherit (osConfig.my) email;
                name = osConfig.my.fullName;
              };
            };
          };
        };
      };
    profile-desktop =
      { config, osConfig, ... }:
      {
        programs.git.signing = {
          format = "ssh";
          key = osConfig.sops.secrets."users/${config.home.username}/ssh/id_ed25519".path;
          signByDefault = true;
        };
      };
  };
}
