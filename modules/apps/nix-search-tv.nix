{
  flake.modules.homeManager.profile-base =
    { lib, pkgs, ... }:
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
      programs.nix-search-tv.enable = lib.mkDefault true;
    };
}
