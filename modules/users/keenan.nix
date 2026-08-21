{
  flake.modules.nixos.base-profile =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = {
        nix.extraOptions = "!include ${
          config.sops.secrets."users/${config.my.user}/github_access_token".path
        }";
        sops.secrets = {
          "users/${config.my.user}/age-key".owner = "${config.my.user}";
          "users/${config.my.user}/github_access_token" = { };
          "users/${config.my.user}/github_pat" = { };
          "users/${config.my.user}/password".neededForUsers = true;
        };
        users.users.${config.my.user} = {
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
        };
      };
      options.my = {
        sshKeys = lib.mkOption {
          default = pkgs.fetchurl {
            hash = "sha256-/LqvDPutUsla5ZKQRRcq8JU5ULaKqJU5S13RJkUR2Ek=";
            name = "keenan-ssh-keys";
            url = "https://codeberg.org/Keenan.keys";
          };
          type = lib.types.package;
        };
        user = lib.mkOption {
          default = "keenan";
          type = lib.types.str;
        };
      };
    };
}
