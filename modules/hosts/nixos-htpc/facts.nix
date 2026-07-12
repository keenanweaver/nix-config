{
  configurations.nixos.nixos-htpc.module = {
    host = {
      cpu = "5800X";
      fpsLimit = "120,0,60,30";
      gpu = "9060XT";
      pciDev = "0000:08:00.0";
      primaryMonitor = "HDMI-1";
      ztAdapter = "zt6ntckupu";
      ztConcurrency = 4;
    };
  };
}
