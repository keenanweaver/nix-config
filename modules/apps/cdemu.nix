{
  flake.modules.nixos.profile-gaming =
    { config, ... }:
    {
      programs.cdemu = {
        enable = true;
        gui = false;
        image-analyzer = false;
      };
      users.users.${config.my.user}.extraGroups = [ "cdrom" ];
      xdg.mime.defaultApplications = {
        "application/x-alcohol" = "cdemu-client.desktop";
        "application/x-cue" = "cdemu-client.desktop";
        "application/x-gd-rom-cue" = "cdemu-client.desktop";
      };
    };
}
