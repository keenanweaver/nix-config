{ self, ... }:
let
  inherit (self.lib.site) nas;
in
{
  flake.modules.nixos =
    let
      nfsMounts =
        { lib, pkgs, ... }:
        {
          environment.systemPackages = with pkgs; [
            cifs-utils
            nfs-utils
          ];
          fileSystems = builtins.listToAttrs (
            map
              (mount: {
                name = "${nas.mountRoot}/${mount}";
                value = {
                  device = "${nas.host}:/mnt/user/${mount}";
                  fsType = "nfs";
                  options = [
                    "_netdev"
                    "hard"
                    "noauto"
                    "noatime"
                    "nofail"
                    "x-systemd.automount"
                    "x-systemd.idle-timeout=60"
                    "x-systemd.mount-timeout=10s"
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
          systemd.services.force-umount-nfs = {
            wantedBy = [ "multi-user.target" ];
            after = [ "network.target" ];
            serviceConfig = {
              ExecStop = "${lib.getExe' pkgs.util-linux "umount"} -f -l -a -t nfs,nfs4";
              RemainAfterExit = true;
              Type = "oneshot";
            };
          };
        };
    in
    {
      profile-desktop = nfsMounts;
      profile-server = nfsMounts;
    };
}
