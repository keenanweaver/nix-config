{
  configurations.nixos.nixos-htpc.module.boot.kernelParams = [
    "amd_pstate=active" # https://wiki.archlinux.org/title/CPU_frequency_scaling#Autonomous_frequency_scaling
  ];
}
