{ inputs, home-manager, lib, config, username, ... }: with lib;
let
  cfg = config.secrets;
in
{
  options = {
    secrets = {
      enable = mkEnableOption "Enable secrets in NixOS & home-manager";
    };
  };
  config = mkIf cfg.enable {
    #nixosConfiguration = {
    sops = {
      age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
      defaultSopsFile = ./secrets.yaml;
      defaultSopsFormat = "yaml";
      secrets = {
        pass = { };
      };
    };
    #};
    home-manager.users.${username} = { inputs, lib, config, username, pkgs, ... }: {
      sops = {
        age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
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
