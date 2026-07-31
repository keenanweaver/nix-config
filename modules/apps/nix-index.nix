{
  flake.modules.homeManager.base-profile =
    { inputs, ... }:
    {
      imports = [
        inputs.nix-index-database.homeModules.nix-index
      ];
      programs.nix-index = {
        enable = true;
        enableBashIntegration = true;
        enableNushellIntegration = true;
        enableZshIntegration = true;
      };
    };
  flake-file.inputs = {
    nix-index-database.url = "github:Mic92/nix-index-database";
  };
}
