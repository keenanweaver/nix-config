{
  configurations.nixos.nixos-desktop.module.host = {
    cpu = "7950X3D";
    cpuHasVcache = true;
    fpsLimit = "324,0,240,120,60,30";
    gpu = "7900XTX";
    lanInterface = "enp10s0";
    pciDev = "0000:03:00.0";
    primaryMonitor = "DP-1";
    wineCpuTopology = "15:1,2,3,4,5,6,7,16,17,18,19,20,21,22,23";
    ztAdapter = "zt6ntckupu";
    ztConcurrency = 16;
  };
}
