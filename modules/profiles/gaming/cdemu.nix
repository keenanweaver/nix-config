{
  flake.modules.nixos.gaming-profile = { config, ... }: {
    programs.cdemu = {
      enable = true;
      gui = false;
      image-analyzer = false;
    };

    users.users.${config.my.user}.extraGroups = [ "cdrom" ];
  };
}
