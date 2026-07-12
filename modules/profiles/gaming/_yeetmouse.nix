{
  flake.modules.nixos.gaming-profile = { inputs, ... }: {
    imports = [
      inputs.yeetmouse.nixosModules.default
    ];
    hardware.yeetmouse = {
      enable = true;
      sensitivity = 1.0;
    };
  };
  flake-file.inputs = {
    yeetmouse = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:AndyFilter/YeetMouse?dir=nix";
    };
  };
}
