{
  flake.modules.homeManager.base-profile = { inputs, ... }: {
    imports = [
      inputs.pedantix.homeModules.default
    ];
    programs.pedantix = {
      enable = true;
      settings = {
        lets.sort = true;
        preset = "nixos-module";
      };
    };
  };
  flake-file.inputs = {
    pedantix.url = "github:swarsel/pedantix";
  };
}
