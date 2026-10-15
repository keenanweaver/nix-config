{
  flake.modules.homeManager.profile-gaming =
    { config, pkgs, ... }:
    {
      home.packages = with pkgs; [ heroic ];
      # Force Heroic to choose my default Proton first
      systemd.user.tmpfiles.rules =
        let
          compatTool = config.programs.steam.config.defaultCompatTool;
        in
        [
          ''L+ "%h/.config/heroic/tools/proton/${compatTool}" - - - - %h/.local/share/Steam/compatibilitytools.d/${compatTool}''
        ];
    };
}
