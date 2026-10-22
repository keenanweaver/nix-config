{
  flake.modules.homeManager.profile-gaming =
    { pkgs, osConfig, ... }:
    {
      home.packages = with pkgs; [ heroic ];
      # Force Heroic to choose my default Proton first
      systemd.user.tmpfiles.rules =
        let
          compatTool = osConfig.programs.steam.client.defaultCompatTool;
        in
        [
          ''L+ "%h/.config/heroic/tools/proton/${compatTool}" - - - - %h/.local/share/Steam/compatibilitytools.d/${compatTool}''
        ];
    };
}
