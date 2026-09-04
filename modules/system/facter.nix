{
  flake.modules.nixos.profile-base =
    { lib, config, ... }:
    let
      reportPath = ../../assets/hosts/${config.networking.hostName}/facter.json;
    in
    {
      hardware.facter.reportPath = lib.mkIf (builtins.pathExists reportPath) reportPath;
    };
}
