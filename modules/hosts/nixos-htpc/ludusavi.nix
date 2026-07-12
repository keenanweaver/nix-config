{
  configurations.nixos.nixos-htpc.module = { config, ... }: {
    home-manager.users.${config.my.user} = { config, ... }: {
      services.ludusavi.settings.backup.path = "${config.home.homeDirectory}/Games/ludusavi";
    };
  };
}
