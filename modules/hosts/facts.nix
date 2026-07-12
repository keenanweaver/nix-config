{
  flake.modules.nixos.base-profile = { lib, ... }: {
    options.host = {
      cpu = lib.mkOption {
        default = "";
        type = lib.types.str;
      };
      fpsLimit = lib.mkOption {
        default = "";
        type = lib.types.str;
      };
      gpu = lib.mkOption {
        default = "";
        type = lib.types.str;
      };
      pciDev = lib.mkOption {
        default = "";
        type = lib.types.str;
      };
      primaryMonitor = lib.mkOption {
        default = "";
        type = lib.types.str;
      };
      ztAdapter = lib.mkOption {
        default = "";
        type = lib.types.str;
      };
      ztConcurrency = lib.mkOption {
        default = 2;
        type = lib.types.int;
      };
    };
  };
}
