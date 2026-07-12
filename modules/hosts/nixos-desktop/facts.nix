{
  configurations.nixos.nixos-desktop.module = {
    host = {
      cpu = "7950X3D";
      fpsLimit = "324,0,240,120,60,30";
      gpu = "7900XTX";
      pciDev = "0000:03:00.0";
      primaryMonitor = "DP-1";
      ztAdapter = "zt6ntckupu";
      ztConcurrency = 16;
    };
  };
}
