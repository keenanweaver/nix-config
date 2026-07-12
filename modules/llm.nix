{
  flake.modules.homeManager.llm =
    {
      lib,
      pkgs,
      inputs,
      ...
    }:
    {
      programs.claude-code = {
        enable = true;
        package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code;
        enableMcpIntegration = true;
        settings = {
          includeCoAuthoredBy = false;
          theme = "dark";
        };
      };

      programs.mcp = {
        enable = true;
        servers.nix.command = lib.getExe pkgs.mcp-nixos;
      };
    };
  flake-file.inputs = {
    llm-agents.url = "github:numtide/llm-agents.nix";
  };
}
