{
  configurations.nixos.nixos-desktop.module =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      home-manager.users.${config.my.user} =
        { config, ... }:
        {
          programs.steam.config =
            let
              defaultOptions = {
                env = { };
                preHook = ''
                  ${lib.getExe lowlatency}
                '';
                wrappers = [
                  (lib.getExe pkgs.local.game-wrapper)
                ];
              };
              defaultProton = "Proton-CachyOS Latest";
              lowlatency = pkgs.writeShellApplication {
                name = "lowlatency";
                runtimeInputs = with pkgs; [
                  scx-loader
                ];
                text = ''
                  scxctl start --sched scx_cake --mode lowlatency
                '';
              };
            in
            {
              apps =
                lib.mapAttrs
                  (
                    _: options:
                    lib.mkMerge [
                      options
                      defaultOptions
                    ]
                  )
                  {
                    "1144200" = {
                      compatTool = config.programs.steam.config.defaultCompatTool;
                      env.PROTON_USE_OPTISCALER = true;
                      name = "Ready Or Not";
                    };
                    "1167630" = {
                      compatTool = config.programs.steam.config.defaultCompatTool;
                      name = "Teardown";
                    };
                    "130".name = "Half-Life: Blue Shift";
                    "1364780" = {
                      compatTool = config.programs.steam.config.defaultCompatTool;
                      name = "Street Fighter 6";
                    };
                    "1659040" = {
                      args = [
                        "-skip_launcher"
                      ];
                      env.PROTON_VKD3D_LOWLATENCY = true;
                      name = "Hitman: World of Assassination";
                    };
                    "225840" = {
                      env = {
                        PROTON_ENABLE_WAYLAND = lib.mkForce false; # Allows mouse to be OBS captured
                      };
                      name = "Sven Co-op";
                    };
                    "2386720" = {
                      compatTool = config.programs.steam.config.defaultCompatTool;
                      env = {
                        MANGOHUD_CONFIG = "read_cfg,fps_limit=0";
                        PROTON_DXVK_LOWLATENCY = true;
                      };
                      name = "STRAFTAT";
                    };
                    "328070" = {
                      env = {
                        MANGOHUD_CONFIG = "read_cfg,fps_limit=0";
                        PROTON_DXVK_LOWLATENCY = true;
                        #PROTON_ENABLE_WAYLAND = lib.mkForce false; # Workshop
                      };
                      name = "Reflex Arena";
                    };
                    "50".name = "Half-Life: Opposing Force";
                    "70".name = "Half-Life";
                  };
              defaultCompatTool = lib.mkForce defaultProton;
            };
        };
    };
}
