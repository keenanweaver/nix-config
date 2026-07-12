{
  flake.modules.nixos.base-profile =
    { config, pkgs, ... }:
    {
      nix.extraOptions = "!include ${
        config.sops.secrets."users/${config.my.user}/github_access_token".path
      }";
      sops.secrets = {
        "users/${config.my.user}/age-key".owner = "${config.my.user}";
        "users/${config.my.user}/github_access_token" = { };
        "users/${config.my.user}/password" = {
          neededForUsers = true;
        };
      };
      users.users.${config.my.user} = {
        extraGroups = [
          "i2c"
          "input"
          "networkmanager"
          "plugdev"
          "uinput"
          "video"
          "wheel"
          "ydotool"
        ];
        hashedPasswordFile = config.sops.secrets."users/${config.my.user}/password".path;
        isNormalUser = true;
        openssh.authorizedKeys.keyFiles = [
          (pkgs.fetchurl {
            hash = "sha256-eSpmgfMYpExkI7l1ko55hytutvalj7QJHtsQEzUw99I=";
            name = "keenan-ssh-keys";
            url = "https://codeberg.org/Keenan.keys";
          })
        ];
      };
    };
}
