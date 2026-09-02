{
  flake.modules.nixos.profile-base =
    {
      self,
      lib,
      config,
      ...
    }:
    {
      imports = [ self.modules.nixos.ssh-keys ];
      config = {
        nix.extraOptions = "!include ${
          config.sops.secrets."users/${config.my.user}/github_access_token".path
        }";
        sops.secrets = {
          "users/${config.my.user}/age-key".owner = "${config.my.user}";
          "users/${config.my.user}/github_access_token" = { };
          "users/${config.my.user}/github_pat" = { };
          "users/${config.my.user}/password".neededForUsers = true;
          "users/${config.my.user}/ssh/id_ed25519" = {
            mode = "0400";
            owner = "${config.my.user}";
            path = "/home/${config.my.user}/.ssh/id_ed25519";
          };
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
      options.my.user = lib.mkOption {
        default = "keenan";
        type = lib.types.str;
      };
    };
}
