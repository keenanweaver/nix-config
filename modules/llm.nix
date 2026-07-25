{
  flake-file.inputs = {
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  flake.modules.homeManager.llm =
    {
      lib,
      pkgs,
      inputs,
      ...
    }:
    {
      programs = {
        claude-code = {
          enable = true;
          enableMcpIntegration = true;
          package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code;

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
}
