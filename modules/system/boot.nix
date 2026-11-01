{ inputs, ... }:
{
  flake.modules.nixos.profile-desktop =
    { lib, pkgs, ... }:
    {
      imports = [ inputs.nixos-plymouth.nixosModules.default ];
      boot = {
        consoleLogLevel = 0;
        kernel.sysctl = {
          "kernel.nmi_watchdog" = lib.mkDefault 0;
          "kernel.soft_watchdog" = 0;
        };
        kernelParams = [
          "loglevel=0"
          "nowatchdog"
          "quiet"
          "splash"
          "systemd.show_status=auto"
          "udev.log_level=3"
          "vt.global_cursor_default=0"
        ];
        loader = {
          efi.canTouchEfiVariables = true;
          limine = {
            enable = true;
            additionalFiles = {
              "efi/memtest86/mt86plus.efi" = "${pkgs.memtest86plus}/mt86plus.efi";
              "efi/netbootxyz/netboot.xyz.efi" = "${pkgs.netbootxyz-efi}";
            };
            extraEntries = ''
              /Tools
              //MemTest86+
                protocol: efi
                comment: ${pkgs.memtest86plus.meta.description}
                path: boot():/limine/efi/memtest86/mt86plus.efi
              //netboot.xyz
                protocol: efi
                comment: ${pkgs.netbootxyz-efi.meta.description}
                path: boot():/limine/efi/netbootxyz/netboot.xyz.efi
            '';
          };
          timeout = lib.mkDefault 1;
        };
        plymouth.enable = true;
      };
      services.nixos-plymouth.enable = lib.mkDefault true;
    };
  flake-file.inputs.nixos-plymouth = {
    inputs = {
      nixos-branding.inputs = {
        flake-compat.follows = "flake-compat";
        pre-commit-hooks.follows = "git-hooks-nix";
        treefmt-nix.follows = "treefmt-nix";
      };
      nixpkgs.follows = "nixpkgs";
    };
    url = "github:iltgg/nixos_plymouth";
  };
}
