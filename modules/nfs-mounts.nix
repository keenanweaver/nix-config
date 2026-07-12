{
  flake.modules.nixos.base-profile = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      cifs-utils
      nfs-utils
    ];
    fileSystems = builtins.listToAttrs (
      map
        (mount: {
          name = "/mnt/crusader/${mount}";
          value = {
            options = [
              "x-systemd.automount"
              "x-systemd.idle-timeout=600"
              "noauto"
              "noatime"
              "nofail"
            ];
            device = "crusader:/mnt/user/${mount}";
            fsType = "nfs";
          };
        })
        [
          "Backup"
          "Downloads"
          "Games"
          "Life"
          "Media"
          "Miscellaneous"
          "Photos"
          "Projects"
        ]
    );
    services.rpcbind.enable = true;
  };
}
