{
  flake.modules.nixos.gaming-profile =
    { pkgs, ... }:
    {
      services.lact = {
        enable = true;
        package = pkgs.master.lact;
      };
    };
}
