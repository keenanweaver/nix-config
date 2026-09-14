{
  flake.modules.homeManager.gaming-profile = { inputs, pkgs, ... }: {
    imports = [ inputs.omniflake.flakes.volt-gui-nix.nixosModules.default ];
    home.packages = with pkgs; [ inputs.volt-gui.packages.${stdenv.hostPlatform.system}.default ];
  };
}
