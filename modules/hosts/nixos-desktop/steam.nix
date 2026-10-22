{
  configurations.nixos.nixos-desktop.module =
    { config, ... }:
    {
      programs.steam.client = {
        extraSettings.defaultInstallFolderIndex = 1;
        games =
          let
            compatTool = config.programs.steam.client.defaultCompatTool;
          in
          {
            # Ready Or Not
            "1144200" = {
              inherit compatTool;
              environment.PROTON_USE_OPTISCALER = true;
            };
            # Teardown
            "1167630" = { inherit compatTool; };
            # Street Fighter 6
            "1364780" = { inherit compatTool; };
            # Hitman: World of Assassination
            "1659040" = {
              environment.PROTON_VKD3D_LOWLATENCY = true;
              launchOptions = "%command% -skip_launcher";
            };
            # Sven Co-op
            "225840".environment.PROTON_ENABLE_WAYLAND = false; # Allows mouse to be OBS captured
            # STRAFTAT
            "2386720" = {
              inherit compatTool;
              environment = {
                MANGOHUD_CONFIG = "read_cfg,fps_limit=0";
                PROTON_DXVK_LOWLATENCY = true;
              };
            };
            # Reflex Arena
            "328070".environment = {
              MANGOHUD_CONFIG = "read_cfg,fps_limit=0";
              PROTON_DXVK_LOWLATENCY = true;
            };
          };
        libraryFolders = [
          "/mnt/Games/SteamLibrary"
          "/mnt/Games2/SteamLibrary"
        ];
      };
    };
}
