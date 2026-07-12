{
  flake.modules.nixos.base-profile = {
    hardware.facter = {
      enable = true;
    };
  };
}
