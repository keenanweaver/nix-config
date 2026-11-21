{
  configurations.nixos.nixos-desktop.module = _: {
    boot = {
      blacklistedKernelModules = [ "snd_hda_intel" ];
      kernel.sysctl = {
        "vm.watermark_boost_factor" = 0;
        "vm.watermark_scale_factor" = 125;
      };
      kernelParams = [
        "amdgpu.audio=0"
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
