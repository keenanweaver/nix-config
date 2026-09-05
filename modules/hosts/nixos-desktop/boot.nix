{
  configurations.nixos.nixos-desktop.module.boot = {
    blacklistedKernelModules = [ "snd_hda_intel" ];
    kernel.sysctl = {
      "vm.page-cluster" = 0;
      "vm.swappiness" = 1;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
    };
    kernelParams = [
      "amdgpu.audio=0"
      #"amd_3d_vcache.x3d_mode=cache" # AMD V-Cache https://wiki.cachyos.org/configuration/general_system_tweaks/#amd-3d-v-cache-optimizer
      "amd_iommu=on"
      "amd_pstate=active" # https://wiki.archlinux.org/title/CPU_frequency_scaling#Autonomous_frequency_scaling
    ];
    loader.limine = {
      extraEntries =
        let
          windowspartuuid = "360eceef-be4b-4477-8d89-af08b7edb5c8";
        in
        ''
          /+Windows
          //Windows 11 IoT Enterprise LTSC
              protocol: efi
              path: uuid(${windowspartuuid}):/EFI/Microsoft/Boot/bootmgfw.efi
        '';
      resolution = "2560x1440x32";
      style.interface.resolution = "2560x1440";
    };
  };
}
