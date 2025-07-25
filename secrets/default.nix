{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.secrets;
in
{
  options = {
    secrets = {
      enable = lib.mkEnableOption "Enable secrets in NixOS & home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    sops = {
      age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
      defaultSopsFile = ./secrets.yaml;
      defaultSopsFormat = "yaml";
      secrets = {
        github_token = { };
        pass = {
          neededForUsers = true;
        };
      };
      templates = {
        "nix-github-token.conf" = {
          content = ''
            access-tokens = "${config.sops.placeholder.github_token}"
          '';
        };
      };
    };
    home-manager.users.${username} =
      { config, ... }:
      {
        sops = {
          age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
          defaultSopsFile = ./secrets.yaml;
          defaultSopsFormat = "yaml";
          defaultSymlinkPath = "/run/user/1000/secrets";
          defaultSecretsMountPoint = "/run/user/1000/secrets.d";
          secrets = {
            "unraid/ntfy/url" = { };
            "unraid/ntfy/user" = { };
            "unraid/ntfy/password" = { };
          };
        };
      };
  };
}
