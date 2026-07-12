{
  configurations.nixos.nixos-desktop.module = {
    services.ucodenix = {
      cpuModelId = "00A60F12";
    };
  };
}
