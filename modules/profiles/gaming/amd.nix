{
  flake.modules = {
    homeManager.amd = { pkgs, ... }: {
      home.packages = with pkgs; [
        amdgpu_top
        nvtopPackages.amd
      ];
    };
    nixos.amd = {
      hardware = {
        amdgpu = {
          initrd.enable = true;
          overdrive = {
            enable = true;
            ppfeaturemask = "0xffffffff";
          };
        };
        cpu.amd.updateMicrocode = true;
      };
    };
  };
}
