{
  configurations.nixos.nixos-desktop.module =
    { lib, ... }:
    {
      boot = {
        blacklistedKernelModules = [ "snd_hda_intel" ];
        kernel.sysctl = {
          "vm.swappiness" = lib.mkForce 1;
          "vm.watermark_boost_factor" = 0;
          "vm.watermark_scale_factor" = 125;
        };
        kernelParams = [
          "amdgpu.audio=0"
          #"amd_3d_vcache.x3d_mode=cache" # AMD V-Cache https://wiki.cachyos.org/configuration/general_system_tweaks/#amd-3d-v-cache-optimizer
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
    };
}
