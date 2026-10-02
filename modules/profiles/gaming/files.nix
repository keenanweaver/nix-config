{ inputs, ... }:
{
  flake.modules.homeManager.profile-gaming =
    {
      lib,
      config,
      pkgs,
      osConfig,
      ...
    }:
    {
      home.file =
        let
          inherit (osConfig.host)
            primaryMonitor
            ;
        in
        lib.optionalAttrs osConfig.services.desktopManager.plasma6.enable {
          "Games/toggle-hdr.sh".source =
            with pkgs;
            lib.getExe (writeShellApplication {
              name = "toggle-hdr";
              runtimeInputs = [
                kdePackages.libkscreen
                jq
              ];
              text = ''
                hdr_status=$(kscreen-doctor --json | jq -r --arg s "${primaryMonitor}" '.outputs[] | select(.name == $s) | .hdr')
                if [ "$hdr_status" = "false" ]; then
                  kscreen-doctor "output.${primaryMonitor}.hdr.enable"
                  kscreen-doctor "output.${primaryMonitor}.wcg.enable"
                elif [ "$hdr_status" = "true" ]; then
                  kscreen-doctor "output.${primaryMonitor}.hdr.disable"
                  kscreen-doctor "output.${primaryMonitor}.wcg.disable"
                  kscreen-doctor "output.${primaryMonitor}.wcg.enable"
                fi
              '';
            });
          "Games/toggle-vrr.sh".source =
            with pkgs;
            lib.getExe (writeShellApplication {
              name = "toggle-vrr";
              runtimeInputs = [
                kdePackages.libkscreen
                jq
              ];
              text = ''
                vrr_policy=$(kscreen-doctor --json | jq -r --arg s "${primaryMonitor}" '.outputs[] | select(.name == $s) | .vrrPolicy')
                if [ "$vrr_policy" = "0" ]; then
                  kscreen-doctor "output.${primaryMonitor}.vrrpolicy.automatic"
                else
                  kscreen-doctor "output.${primaryMonitor}.vrrpolicy.never"
                fi
              '';
            });
        };
      xdg.configFile = {
        "dosbox/mt32-roms".source = "${inputs.nonfree}/Music/roland/mt32";
        "dosbox/soundcanvas-roms".source = "${inputs.nonfree}/Music/roland/sc55";
        "dosbox/soundfonts/default.sf2".source = config.services.fluidsynth.soundFont;
      };
    };
}
