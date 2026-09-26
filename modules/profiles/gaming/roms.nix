{
  flake.lib = {
    pinRoms =
      pkgs: roms:
      map (
        rom:
        pkgs.requireFile {
          inherit (rom) hash name;
          message = ''
            ${rom.name} (${rom.game}) is missing from the Nix store. Add dump with
              nix-store --add-fixed sha256 ${rom.name}
            or copy it from a host that has it:
              nix copy --to ssh-ng://<host> <store path>
          '';
        }
      ) roms;
    roms = {
      banjo = {
        game = "Banjo-Kazooie (US 1.0), for banjorecomp";
        hash = "sha256-WYdYNbmlEouwBUMVp/kp4gccIAHlKNcL9UPh1mgObv8=";
        name = "baserom.us.v10.z64";
      };
      mm = {
        game = "Majora's Mask (US rev1), for zelda64recomp";
        hash = "sha256-77E2WzrjYmBFFMD5oaLRH13IaIulvmYKN96/XjvkPys=";
        name = "mm.us.rev1.rom.z64";
      };
      sm64 = {
        game = "Super Mario 64 (US), for sm64ex";
        hash = "sha256-F84Hc0PGEz+Mny1tbZpKtiyM0qpXxArqH0kLTIuyHZE=";
        name = "baserom.us.z64";
      };
    };
  };
}
