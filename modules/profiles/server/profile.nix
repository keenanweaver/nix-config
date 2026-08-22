{
  flake.modules = {
    homeManager.profile-server =
      { inputs, ... }:
      {
        imports = [
          inputs.nix-podman-stacks.homeModules.nps
          inputs.quadlet-nix.homeManagerModules.quadlet
        ];
      };
    nixos.profile-server =
      { inputs, config, ... }:
      {
        imports = [
          inputs.microvm.nixosModules.microvm
          inputs.quadlet-nix.nixosModules.quadlet
        ];
        # https://tarow.github.io/nix-podman-stacks/docs/getting-started.html#%E2%9A%99%EF%B8%8F-prerequisites
        boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 0;
        users.users.${config.my.user} = {
          autoSubUidGidRange = true;
          linger = true;
        };
        virtualisation.quadlet = {
          enable = true;
          autoUpdate.enable = true;
        };
      };
  };
  flake-file.inputs = {
    microvm = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:microvm-nix/microvm.nix";
    };
    nix-podman-stacks = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Tarow/nix-podman-stacks";
    };
    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";
  };
}
