{
  configurations.nixos.remorse.module = { config, ... }: {
    home-manager.users.${config.my.user} =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [ local.lgogdownloader ];
      };
  };
}
