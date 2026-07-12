{ inputs, ... }:
{
  flake.modules.homeManager.gaming-profile =
    { lib, pkgs, ... }:
    let
      steamCompatTools = with pkgs; [
        proton-cachyos
        local.proton-em
      ];
    in
    {
      programs.lutris.protonPackages = steamCompatTools;

      systemd.user.services.protonplus-update = {
        Service = {
          ExecStart = "${lib.getExe pkgs.protonplus} update all";
          ExecStartPost = "${lib.getExe pkgs.libnotify} --app-name=ProtonPlus --icon=com.vysp3r.ProtonPlus 'ProtonPlus' 'Proton runners updated'";
          Type = "oneshot";
        };
        Unit.Description = "Update runners for protonplus";
      };
      systemd.user.timers.protonplus-update = {
        Install.WantedBy = [ "timers.target" ];
        Timer.OnStartupSec = "5s";
        Unit.Description = "Run protonplus update on boot";
      };

      xdg.dataFile = lib.genAttrs' steamCompatTools (
        tool:
        lib.nameValuePair "Steam/compatibilitytools.d/${lib.getName tool}" {
          source = tool.steamcompattool;
        }
      );
    };
  flake.modules.nixos.gaming-profile =
    { pkgs, ... }:
    let
      steamCompatTools = with pkgs; [
        proton-cachyos
        local.proton-em
      ];
    in
    {
      nixpkgs.overlays = [
        (_final: prev: {
          proton-cachyos = inputs.nix-gaming-edge.packages.${prev.stdenv.hostPlatform.system}.proton-cachyos;
        })
      ];

      programs.steam.extraCompatPackages = steamCompatTools;
    };
}
