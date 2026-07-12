{
  flake.modules = {
    nixos.base-profile = { pkgs, ... }: {
      boot = {
        kernel = {
          sysctl = {
            "kernel.nmi_watchdog" = 0;
            "kernel.soft_watchdog" = 0;
            "kernel.sysrq" = 4;
          };
        };
        kernelParams = [
          "nowatchdog"
        ];
        loader = {
          efi.canTouchEfiVariables = true;
          limine = {
            enable = true;
            additionalFiles = {
              "efi/memtest86/mt86plus.efi" = "${pkgs.memtest86plus}/mt86plus.efi";
              "efi/netbootxyz/netboot.xyz.efi" = "${pkgs.netbootxyz-efi}";
            };
            extraEntries = ''
              /Tools
              //MemTest86+
                protocol: efi
                comment: ${pkgs.memtest86plus.meta.description}
                path: boot():/limine/efi/memtest86/mt86plus.efi
              //netboot.xyz
                protocol: efi
                comment: ${pkgs.netbootxyz-efi.meta.description}
                path: boot():/limine/efi/netbootxyz/netboot.xyz.efi
            '';
          };
          timeout = 1;
        };
      };
    };
  };
}
