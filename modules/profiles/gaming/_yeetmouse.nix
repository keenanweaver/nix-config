{
  flake.modules.nixos.gaming-profile =
    { inputs, config, ... }:
    {
      imports = [
        inputs.yeetmouse.nixosModules.default
      ];

      hardware.yeetmouse = {
        enable = true;
        sensitivity = 1.0;
      };

      preservation.preserveAt."/persist".files = [
        "/etc/yeetmouse.conf"
      ];

      users = {
        groups.yeetmouse = { };
        users.${config.my.user}.extraGroups = [ "yeetmouse" ];
      };
    };

  flake-file.inputs.yeetmouse = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:AndyFilter/YeetMouse?dir=nix";
  };
}
