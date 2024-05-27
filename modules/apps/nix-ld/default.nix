{
  lib,
  config,
  username,
  pkgs,
  ...
}:
let
  cfg = config.nix-ld;
in
{
  options = {
    nix-ld = {
      enable = lib.mkEnableOption "Enable nix-ld in NixOS";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.nix-ld = {
      enable = true;
      # https://reddit.com/r/NixOS/comments/1d1nd9l/walking_through_why_precompiled_hello_world/l5vpcdi/?context=3
      libraries = pkgs.steam-run.fhsenv.args.multiPkgs pkgs;
    };
    home-manager.users.${username} = { };
  };
}
