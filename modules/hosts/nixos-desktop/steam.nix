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
                launchOptions = {
                  env = { };

                  preHook = ''
                    ${lib.getExe lowlatency}
                  '';

                  wrappers = [
                    (lib.getExe pkgs.local.game-wrapper)
                  ];
                };
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
                    "Half-Life".id = 70;
                    "Half-Life: Blue Shift".id = 130;
                    "Half-Life: Opposing Force".id = 50;

                    "Helldivers 2" = {
                      compatTool = config.programs.steam.config.defaultCompatTool;
                      id = 553850;

                      launchOptions = {
                        args = [
                          "+connect_lobby -1" # Skip intro
                        ];

                        env = {
                          PROTON_VKD3D_LOWLATENCY = true;
                          WINE_CPU_TOPOLOGY = "8:1,2,3,4,5,6,7,16"; # https://github.com/ValveSoftware/Proton/issues/7486#issuecomment-2683254539
                        };
                      };
                    };

                    "Hitman: World of Assassination" = {
                      id = 1659040;

                      launchOptions = {
                        args = [
                          "-skip_launcher"
                        ];

                        env.PROTON_VKD3D_LOWLATENCY = true;
                      };
                    };

                    "Quake Live" = {
                      id = 282440;

                      launchOptions.env = {
                        PROTON_DXVK_LOWLATENCY = true;
                        # https://steamcommunity.com/sharedfiles/filedetails/?id=3642772367
                        # mesa_glthread = "false";
                        # MESA_GL_VERSION_OVERRIDE = "3.2";
                      };
                    };

                    "Ready or Not" = {
                      compatTool = config.programs.steam.config.defaultCompatTool;
                      id = 1144200;

                      launchOptions.env = {
                        LOW_LATENCY_LAYER = true;
                        PROTON_USE_OPTISCALER = true;
                      };
                    };

                    "Reflex Arena" = {
                      id = 328070;

                      launchOptions.env = {
                        MANGOHUD_CONFIG = "read_cfg,fps_limit=0";
                        PROTON_DXVK_LOWLATENCY = true;
                        #PROTON_ENABLE_WAYLAND = lib.mkForce false; # Workshop
                      };
                    };

                    "STRAFTAT" = {
                      compatTool = config.programs.steam.config.defaultCompatTool;
                      id = 2386720;

                      launchOptions.env = {
                        MANGOHUD_CONFIG = "read_cfg,fps_limit=0";
                        PROTON_DXVK_LOWLATENCY = true;
                      };
                    };

                    "Street Fighter 6" = {
                      compatTool = config.programs.steam.config.defaultCompatTool;
                      id = 1364780;
                    };

                    "Sven Co-op" = {
                      id = 225840;

                      launchOptions.env = {
                        PROTON_ENABLE_WAYLAND = lib.mkForce false; # Allows mouse to be OBS captured
                      };
                    };

                    "Teardown" = {
                      compatTool = config.programs.steam.config.defaultCompatTool;
                      id = 1167630;
                    };
                  };

              defaultCompatTool = lib.mkForce defaultProton;
            };
        };
    };
}
