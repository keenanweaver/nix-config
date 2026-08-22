{
  flake.modules.nixos.profile-base = { config, ... }: {
    hardware.facter = {
      enable = true;
      reportPath = ../../assets/hosts/${config.networking.hostName}/facter.json;
    };
  };
}
