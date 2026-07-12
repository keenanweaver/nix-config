{
  flake.modules.homeManager.server-profile = { inputs, ... }: {
    imports = [
      inputs.nix-podman-stacks.homeModules.nps
      inputs.quadlet-nix.homeManagerModules.quadlet
    ];
  };
  flake.modules.nixos.server-profile = { config, inputs, ... }: {
    imports = [
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
  flake-file.inputs = {
    nix-podman-stacks = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Tarow/nix-podman-stacks";
    };
    quadlet-nix = {
      url = "github:SEIAROTg/quadlet-nix";
    };
  };
}
