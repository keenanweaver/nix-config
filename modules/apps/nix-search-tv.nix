{
  flake.modules.homeManager.profile-base =
    { pkgs, ... }:
    {
      home.packages = [
        (pkgs.writeShellApplication {
          name = "ns";
          runtimeInputs = with pkgs; [
            fzf
            nix-search-tv
          ];
          text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
        })
      ];
      programs.nix-search-tv.enable = true;
    };
}
