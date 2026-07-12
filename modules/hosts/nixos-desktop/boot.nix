{
  configurations.nixos.nixos-desktop.module = {
    boot = {
      kernel.sysctl = {
        "vm.page-cluster" = 0;
        "vm.swappiness" = 1;
        "vm.watermark_boost_factor" = 0;
        "vm.watermark_scale_factor" = 125;
      };
      kernelParams = [
        "amdgpu.audio=0"
        # Fake display for Sunshine https://mattducharme.dev/posts/fake-linux-display/
        "drm.edid_firmware=HDMI-A-1:edid/gbt-aorus-fo27q3.bin"
        "video=HDMI-A-1:2560x1440@120e"
        #"amd_3d_vcache.x3d_mode=cache" # AMD V-Cache https://wiki.cachyos.org/configuration/general_system_tweaks/#amd-3d-v-cache-optimizer
        "amd_iommu=on"
        "amd_pstate=active" # https://wiki.archlinux.org/title/CPU_frequency_scaling#Autonomous_frequency_scaling
        "amdgpu.mcbp=0"
        # AMDGPU freezing randomly https://gitlab.freedesktop.org/drm/amd/-/issues/4141
        # https://gitlab.freedesktop.org/mesa/mesa/-/issues/14250#note_3181015
        # https://reddit.com/r/linux_gaming/comments/1q1bg71/8_threads_in_2_weeks_amd_gpus_crashing_on/nx5zixu/?context=3#nx5zixu
        # Run 'sudo cat /sys/kernel/debug/dri/128/amdgpu_gpu_recover' to fix
        "amdgpu.runpm=0"
        "amdgpu.dcdebugmask=0x10"
        "amdgpu.aspm=0"
        "amdgpu.gpu_recovery=1"
      ];
      loader = {
        limine = {
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
    };
  };
}
