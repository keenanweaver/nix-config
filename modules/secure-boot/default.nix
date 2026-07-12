{
  flake.modules.nixos.secure-boot =
    { pkgs, ... }:
    let
      cryptenroll = pkgs.writeShellApplication {
        name = "cryptenroll";
        runtimeInputs = [ pkgs.systemd ];
        text = builtins.readFile ./cryptenroll.sh;
      };
    in
    {
      boot.loader.limine.secureBoot.enable = true;

      environment.systemPackages = with pkgs; [
        cryptenroll
        sbctl
      ];

      preservation.preserveAt."/persist".directories = [
        "/etc/secureboot"
        "/var/lib/sbctl"
      ];
    };
}
