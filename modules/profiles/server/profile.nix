{
  flake.modules = {
    homeManager.profile-server =
      { inputs, ... }:
      {
        imports = [
          inputs.omniflake.flakes.nix-podman-stacks.homeModules.nps
        ];
      };
    nixos.profile-server =
      { inputs, config, ... }:
      {
        imports = [
          inputs.omniflake.flakes.quadlet-nix.nixosModules.quadlet
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
}
