{
  flake.modules = {
    homeManager.profile-base.programs.nix-index = {
      enable = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
    };
    nixos.profile-base = { inputs, ... }: {
      imports = [
        inputs.omniflake.flakes.nix-index-database.nixosModules.default
      ];
    };
  };
}
