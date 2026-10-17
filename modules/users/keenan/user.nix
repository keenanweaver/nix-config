{
  flake.modules.nixos = {
    profile-base =
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
          sops.secrets."users/${config.my.user}/password" = {
            neededForUsers = true;
            sopsFile = ../../../assets/secrets/nixos.yaml;
          };
          systemd.tmpfiles.rules = [
            "d ${home}/.ssh 0700 ${config.my.user} users - -"
          ];
          users.users.${config.my.user} = {
            description = config.my.fullName;
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
        options.my = {
          email = lib.mkOption {
            default = "keenanweaver@protonmail.com";
            type = lib.types.str;
          };
          fullName = lib.mkOption {
            default = "Keenan Weaver";
            type = lib.types.str;
          };
          sshKeys = lib.mkOption {
            default = ../../../assets/users/keenan/ssh-keys.pub;
            description = "The user's authorized_keys file, also git's allowed signers.";
            type = lib.types.path;
          };
          user = lib.mkOption {
            default = "keenan";
            type = lib.types.str;
          };
        };
      };
    profile-desktop =
      { config, ... }:
      let
        inherit (config.my) user;
        inherit (config.users.users.${user}) home;
        desktopSecret =
          extra:
          {
            owner = user;
            sopsFile = ../../../assets/secrets/desktop.yaml;
          }
          // extra;
      in
      {
        nix.extraOptions = ''
          !include ${config.sops.secrets."users/${user}/github_access_token".path}
          !include ${config.sops.secrets.nonfree_repo_access_token.path}
        '';
        sops.secrets = {
          nonfree_repo_access_token = desktopSecret { };
          "users/${user}/age-key" = desktopSecret { };
          "users/${user}/github_access_token" = desktopSecret { };
          "users/${user}/github_pat" = desktopSecret { };
          "users/${user}/ssh/id_ed25519" = desktopSecret {
            mode = "0400";
            path = "${home}/.ssh/id_ed25519";
          };
        };
      };
  };
}
