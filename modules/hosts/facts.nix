{
  flake = {
    lib.mkFactAssertions =
      config: facts:
      map (fact: {
        assertion = config.host.${fact} != "";

        message = ''
          host.${fact} is required by a profile imported on '${config.networking.hostName}', but is unset.
          Set it in modules/hosts/${config.networking.hostName}/facts.nix.
        '';
      }) facts;

    modules.nixos.base-profile =
      { lib, ... }:
      let
        mkFact =
          type: default: description:
          lib.mkOption { inherit default description type; };

        mkStrFact = mkFact lib.types.str "";
      in
      {
        options.host = {
          cpu = mkStrFact ''
            Marketing name of the CPU, e.g. "7950X3D". Displayed by MangoHud.
          '';

          cpuHasVcache = mkFact lib.types.bool false ''
            Whether the CPU binds the amd_x3d_vcache driver, i.e. whether
            /sys/bus/platform/drivers/amd_x3d_vcache exists. True only for
            multi-CCD X3D parts such as the 7950X3D; false for the 5800X.
          '';

          fpsLimit = mkStrFact ''
            MangoHud fps_limit cycle, e.g. "324,0,240,120,60,30".
          '';

          gpu = mkStrFact ''
            Marketing name of the GPU, e.g. "7900XTX". Displayed by MangoHud.
          '';

          pciDev = mkStrFact ''
            PCI address of the GPU MangoHud should report on, e.g. "0000:03:00.0".
          '';

          primaryMonitor = mkStrFact ''
            kscreen output name of the primary display, e.g. "DP-1". Used for
            HDR/VRR/WCG queries and Sunshine mode switching.
          '';

          ztAdapter = mkStrFact ''
            ZeroTier interface name for the joined network, e.g. "zt6ntckupu".
          '';

          ztConcurrency = mkFact lib.types.int 2 ''
            ZeroTier worker thread count. Roughly the physical core count.
          '';
        };
      };
  };
}
