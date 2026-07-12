{ inputs, ... }:
{
  flake.modules.homeManager.base-profile =
    {
      config,
      osConfig ? null,
      ...
    }:
    {
      imports = [ inputs.sops-nix.homeManagerModules.sops ];

      sops = {
        age.keyFile =
          if osConfig != null then
            osConfig.sops.secrets."users/${config.home.username}/age-key".path
          else
            "${config.home.homeDirectory}/.config/sops/age/keys.txt";
        defaultSopsFile = ./secrets + "/${config.home.username}.yaml";
        secrets = {
          "libera_pass" = { };
        };
      };
    };
  flake.modules.nixos.base-profile =
    { config, ... }:
    let
      isEd25519 = key: key.type == "ed25519";
      keys = builtins.filter isEd25519 config.services.openssh.hostKeys;
    in
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];

      sops = {
        age.sshKeyPaths = map (key: key.path) keys;
        defaultSopsFile = ./secrets/nixos.yaml;
      };
    };
  flake-file.inputs.sops-nix = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:Mic92/sops-nix";
  };
}
