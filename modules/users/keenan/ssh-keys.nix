{
  flake.modules.nixos.ssh-keys =
    { lib, pkgs, ... }:
    {
      options.my.sshKeys = lib.mkOption {
        default = pkgs.fetchurl {
          hash = "sha256-/LqvDPutUsla5ZKQRRcq8JU5ULaKqJU5S13RJkUR2Ek=";
          name = "keenan-ssh-keys";
          url = "https://codeberg.org/Keenan.keys";
        };
        type = lib.types.package;
      };
    };
}
