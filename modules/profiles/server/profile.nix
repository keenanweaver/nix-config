{ self, inputs, ... }:
let
  inherit (self.lib.site) network;
in
{
  flake.modules = {
    homeManager.profile-server =
      { config, osConfig, ... }:
      {
        imports = [
          inputs.nix-podman-stacks.homeModules.nps
        ];
        nps = {
          externalStorageBaseDir = "${config.home.homeDirectory}/external";
          hostIP4Address = network.hosts.${osConfig.networking.hostName};
        };
      };
    nixos.profile-server =
      { config, ... }:
      {
        imports = [
          inputs.quadlet-nix.nixosModules.quadlet
          self.modules.nixos.profile-base
        ];
        assertions = self.lib.mkFactAssertions config [ "lanInterface" ];
        # https://tarow.github.io/nix-podman-stacks/docs/getting-started.html#%E2%9A%99%EF%B8%8F-prerequisites
        boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 0;
        home-manager.sharedModules = [ self.modules.homeManager.profile-server ];
        networking = {
          defaultGateway = {
            address = network.gateway;
            interface = config.host.lanInterface;
          };
          interfaces.${config.host.lanInterface}.ipv4.addresses = [
            {
              address = network.hosts.${config.networking.hostName};
              prefixLength = 24;
            }
          ];
          nameservers = [ network.gateway ];
        };
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
    nix-podman-stacks = {
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:Tarow/nix-podman-stacks";
    };
    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";
  };
}
