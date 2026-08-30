{ inputs, ... }:
{
  flake.modules = {
    homeManager.profile-base =
      {
        config,
        osConfig ? null,
        ...
      }:
      {
        imports = [ inputs.omniflake.flakes.sops-nix.homeManagerModules.sops ];
        sops = {
          age.keyFile =
            if osConfig != null then
              osConfig.sops.secrets."users/${config.home.username}/age-key".path
            else
              "${config.home.homeDirectory}/.config/sops/age/keys.txt";
          defaultSopsFile = ../../assets/secrets + "/${config.home.username}.yaml";
        };
      };
    nixos.profile-base =
      { config, ... }:
      let
        isEd25519 = key: key.type == "ed25519";
        keys = builtins.filter isEd25519 config.services.openssh.hostKeys;
      in
      {
        imports = [ inputs.omniflake.flakes.sops-nix.nixosModules.sops ];
        sops = {
          age.sshKeyPaths = map (key: key.path) keys;
          defaultSopsFile = ../../assets/secrets/nixos.yaml;
        };
      };
  };
}
