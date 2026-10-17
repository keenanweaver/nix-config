{ inputs, ... }:
let
  secretsDir = ../../assets/secrets;
in
{
  flake.modules = {
    homeManager.profile-desktop =
      { config, osConfig, ... }:
      {
        imports = [ inputs.sops-nix.homeManagerModules.sops ];
        sops = {
          age.keyFile = osConfig.sops.secrets."users/${config.home.username}/age-key".path;
          defaultSopsFile = secretsDir + "/${config.home.username}.yaml";
        };
      };
    nixos.profile-base =
      { config, ... }:
      let
        hostFile = secretsDir + "/${config.networking.hostName}.yaml";
      in
      {
        imports = [ inputs.sops-nix.nixosModules.sops ];
        sops.defaultSopsFile =
          if builtins.pathExists hostFile then hostFile else secretsDir + "/nixos.yaml";
      };
  };
  flake-file.inputs.sops-nix = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:Mic92/sops-nix";
  };
}
