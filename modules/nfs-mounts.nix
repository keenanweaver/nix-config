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
            device = "crusader:/mnt/user/${mount}";
            fsType = "nfs";

            options = [
              "x-systemd.automount"
              "x-systemd.idle-timeout=600"
              "noauto"
              "noatime"
              "nofail"
            ];
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
