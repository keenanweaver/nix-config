{ inputs, ... }:
{
  flake.modules = {
    homeManager.profile-base =
      { config, osConfig, ... }:
      {
        imports = [ inputs.sops-nix.homeManagerModules.sops ];
        sops = {
          age.keyFile = osConfig.sops.secrets."users/${config.home.username}/age-key".path;
          defaultSopsFile = ../../assets/secrets + "/${config.home.username}.yaml";
        };
      };
    nixos.profile-base = {
      imports = [ inputs.sops-nix.nixosModules.sops ];
      sops.defaultSopsFile = ../../assets/secrets/nixos.yaml;
    };
  };
  flake-file.inputs.sops-nix = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:Mic92/sops-nix";
  };
}
