{
  configurations.nixos.nixos-desktop.module = {
    boot.kernelParams = [ "microcode.amd_sha_check=off" ];
    services.ucodenix = {
      cpuModelId = "00A60F12";
    };
  };
}
