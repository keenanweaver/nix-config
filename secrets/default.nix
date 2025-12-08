{
  lib,
  config,
  pkgs,
  username,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    ssh-to-age
    sops
  ];
  sops = {
    age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";
    secrets = {
      github_token = { };
      user_pass = {
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
          "libera_pass" = { };
        };
      };
    };
}
