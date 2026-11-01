{
  flake.modules = {
    homeManager.profile-desktop =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          (writeShellApplication {
            name = "ns";
            runtimeInputs = [
              fzf
              nix-search-tv
            ];
            text = builtins.readFile "${nix-search-tv.src}/nixpkgs.sh";
          })
          gearlever
          libnotify
          qpwgraph
          rustdesk-flutter
        ];
        programs = {
          devenv.enable = true;
          nix-search-tv.enable = true;
          yt-dlp.enable = true;
        };
      };
    nixos.profile-desktop =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          lm_sensors
          pciutils
          xdg-user-dirs
        ];
      };
  };
}
