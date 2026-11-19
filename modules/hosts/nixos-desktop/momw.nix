{ inputs, ... }:
{
  configurations.nixos.nixos-desktop.module =
    { config, ... }:
    {
      home-manager.users.${config.my.user} =
        {
          lib,
          config,
          pkgs,
          ...
        }:
        let
          inherit (pkgs) openmw;
          omw = inputs.openmw-nix.packages.${pkgs.stdenv.hostPlatform.system};
        in
        {
          home = {
            file.".config/openmw/momw-configurator.toml".source =
              (pkgs.formats.toml { }).generate "momw-configurator.toml"
                {
                  FilePaths = {
                    DeltaPluginExe = lib.getExe omw.delta-plugin;
                    GoCoverifyExe = lib.getExe omw.gocoverify;
                    IniImporterExe = lib.getExe' openmw "openmw-iniimporter";
                    LumenaireExe = lib.getExe omw.lumenaire;
                    ModBaseDir = "${config.home.homeDirectory}/Games/openmw";
                    MorrowindDataFiles = "${config.home.homeDirectory}/Games/morrowind/Data Files";
                    MorrowindDotIniPath = "${config.home.homeDirectory}/Games/morrowind/Morrowind.ini";
                    NavmeshtoolExe = lib.getExe' openmw "openmw-navmeshtool";
                    OpenmwExe = lib.getExe' openmw "openmw";
                    ValidatorExe = lib.getExe omw.openmw-validator;
                  };
                };
            packages = [
              (pkgs.writeShellApplication {
                name = "momw-update";
                runtimeEnv.MODLIST = "i-heart-vanilla-directors-cut";
                runtimeInputs = [
                  omw.momw-tools-pack
                  openmw
                ];
                text = ''
                  umo sync "$MODLIST"
                  umo install "$MODLIST"
                  momw-configurator config "$MODLIST" --run-navmeshtool --run-validator
                  umo vacuum
                '';
              })
              omw.momw-tools-pack
              openmw
            ];
          };
          sops = {
            secrets.nexus_pat = { };
            templates."umomwd-config.json" =
              let
                staticConfig = {
                  BASEPATH = "${config.home.homeDirectory}/Games/openmw";
                  CACHE_DIR = "${config.xdg.cacheHome}/umomwd";
                  TES3CMD = lib.getExe pkgs.tes3cmd;
                };
              in
              {
                content = builtins.toJSON (
                  staticConfig
                  // {
                    NEXUS_API_KEY = config.sops.placeholder.nexus_pat;
                  }
                );
                mode = "0600";
                path = "${config.xdg.configHome}/umomwd/config.json";
              };
          };
          xdg.desktopEntries.umo = {
            exec = "${lib.getExe omw.umo} %u";
            icon = "umo";
            mimeType = [
              "x-scheme-handler/momw"
              "x-scheme-handler/nxm"
            ];
            name = "umo NXM/MOMW Scheme Handler";
            noDisplay = true;
            startupNotify = false;
            terminal = false;
          };
        };
      xdg.mime.defaultApplications."x-scheme-handler/momw" = "umo.desktop";
    };
  flake-file.inputs.openmw-nix = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "https://codeberg.org/Keenan/openmw-nix/archive/modernize-packages.tar.gz";
  };
}
