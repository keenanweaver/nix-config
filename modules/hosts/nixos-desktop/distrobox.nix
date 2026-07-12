{
  configurations.nixos.nixos-desktop.module = { config, ... }: {
    home-manager.users.${config.my.user} = {
      programs.distrobox = {
        containers = {
          exodos = {
            image = "docker.io/library/ubuntu:24.04";
            init = true;
          };
        };
        enableSystemdUnit = true;
      };
    };
  };
}
