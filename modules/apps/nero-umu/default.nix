{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.nero-umu;
in
{
  options = {
    nero-umu = {
      enable = lib.mkEnableOption "Enable nero-umu in home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} =
      {
        config,
        inputs,
        pkgs,
        ...
      }:
      {
        home = {
          file = {
            proton-links-proton-cachyos-nero = {
              enable = true;
              source = inputs.chaotic.legacyPackages.${pkgs.stdenv.hostPlatform.system}.proton-cachyos + "/bin";
              target = "${config.xdg.dataHome}/Steam/compatibilitytools.d/GE-Proton10-proton-cachyos-nero-nix";
            };
            proton-links-proton-dw-nero = {
              enable = true;
              source = pkgs.proton-dw.steamcompattool;
              target = "${config.xdg.dataHome}/Steam/compatibilitytools.d/GE-Proton10-proton-dw-nero-nix";
            };
            proton-links-proton-em-nero = {
              enable = true;
              source = pkgs.proton-em.steamcompattool;
              target = "${config.xdg.dataHome}/Steam/compatibilitytools.d/GE-Proton10-proton-em-nero-nix";
            };
            proton-links-proton-ge-nero = {
              enable = true;
              source = pkgs.proton-ge.steamcompattool;
              target = "${config.xdg.dataHome}/Steam/compatibilitytools.d/GE-Proton10-nero-nix";
            };
          };
          packages = with pkgs; [
            nero-umu
          ];
        };
      };
  };
}
