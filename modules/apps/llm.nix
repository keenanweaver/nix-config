{ inputs, ... }:
{
  flake.modules.homeManager.profile-workstation =
    {
      lib,
      pkgs,
      ...
    }:
    {
      programs = {
        claude-code = {
          enable = true;
          package = inputs.llm-agents-nix.packages.${pkgs.stdenv.hostPlatform.system}.claude-code;
          enableMcpIntegration = true;
          settings = {
            includeCoAuthoredBy = false;
            theme = "dark";
          };
        };
        mcp = {
          enable = true;
          servers.nix.command = lib.getExe pkgs.mcp-nixos;
        };
      };
    };
  flake-file.inputs.llm-agents-nix = {
    inputs = {
      nixpkgs.follows = "nixpkgs";
      systems.follows = "systems";
    };
    url = "github:numtide/llm-agents.nix";
  };
}
