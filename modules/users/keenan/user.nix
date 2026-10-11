{ self, ... }:
{
  flake.modules.nixos.profile-base =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      inherit (config.users.users.${config.my.user}) home;
    in
    {
      imports = [ self.modules.nixos.ssh-keys ];
      config = {
        home-manager.users.${config.my.user}.programs =
          let
            githubToken = ''
              if GITHUB_TOKEN="$(env -u GITHUB_TOKEN ${lib.getExe pkgs.gh} auth token 2>/dev/null)"; then
                export GITHUB_TOKEN
              else
                unset GITHUB_TOKEN
              fi
            '';
          in
          {
            bash.initExtra = githubToken;
            zsh.initContent = githubToken;
          };
        nix.extraOptions = ''
          !include ${config.sops.secrets."users/${config.my.user}/github_access_token".path}
          !include ${config.sops.secrets."nonfree_repo_access_token".path}
        '';
        sops.secrets = {
          nonfree_repo_access_token.owner = config.my.user;
          "users/${config.my.user}/age-key".owner = config.my.user;
          "users/${config.my.user}/github_access_token".owner = config.my.user;
          "users/${config.my.user}/github_pat".owner = config.my.user;
          "users/${config.my.user}/password".neededForUsers = true;
          "users/${config.my.user}/ssh/id_ed25519" = {
            mode = "0400";
            owner = config.my.user;
            path = "${home}/.ssh/id_ed25519";
          };
        };
        systemd.tmpfiles.rules = [
          "d ${home}/.ssh 0700 ${config.my.user} users - -"
        ];
        users.users.${config.my.user} = {
          description = "Keenan Weaver";
          extraGroups = [
            "input"
            "uinput"
            "video"
            "wheel"
            "ydotool"
          ];
          hashedPasswordFile = config.sops.secrets."users/${config.my.user}/password".path;
          isNormalUser = true;
          openssh.authorizedKeys.keyFiles = [ config.my.sshKeys ];
          uid = 1000;
        };
      };
      options.my.user = lib.mkOption {
        default = "keenan";
        type = lib.types.str;
      };
    };
}
