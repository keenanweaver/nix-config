{
  lib,
  config,
  username,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.steam;

  # FSR4
  fsrVersion = "67D435F7d97000";
  fsrDll = pkgs.fetchurl {
    url = "https://download.amd.com/dir/bin/amdxcffx64.dll/${fsrVersion}/amdxcffx64.dll";
    sha256 = "sha256-OuTTllFAwQjzKJXbRhV7Ma15AgFo1U+EHFYqH9/EqVw="; # fix hash
    curlOpts = "--referer https://support.amd.com";
  };

  proton-ge-bin-fsr4 =
    (pkgs.proton-ge-bin.override { steamDisplayName = "GE-Proton FSR"; }).overrideAttrs
      (old: {
        installPhase = ''
          runHook preInstall

          # Make it impossible to add to an environment. You should use the appropriate NixOS option.
          # Also leave some breadcrumbs in the file.
          echo "${old.pname} should not be installed into environments. Please use programs.steam.extraCompatPackages instead." > $out

          mkdir $steamcompattool
          cp -a $src/* $steamcompattool
          chmod -R +w $steamcompattool

          rm $steamcompattool/compatibilitytool.vdf
          cp $src/compatibilitytool.vdf $steamcompattool

          runHook postInstall
        '';

        postInstall = ''
          mkdir -p $steamcompattool/files/lib/wine/amdprop
          cp ${fsrDll} $steamcompattool/files/lib/wine/amdprop/amdxcffx64.dll
          echo "${fsrVersion}" > $steamcompattool/files/lib/wine/amdprop/amdxcffx64_version
        '';

        preFixup = (old.preFixup or "") + ''
          substituteInPlace "$steamcompattool/proton" \
            --replace-fail 'if not version_match:' '# if not version_match:' \
            --replace-fail 'with open(g_proton.lib_dir + "wine/amdprop/amdxcffx64_version", "w") as file:' '# with open(g_proton.lib_dir + "wine/amdprop/amdxcffx64_version", "w") as file:' \
            --replace-fail 'file.write(versions[1] + "\n")' '# file.write(versions[1] + "\n")'
        '';
      });
in
{
  options.steam = {
    enable = lib.mkEnableOption "Enable Steam in NixOS";
    enableFlatpak = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    enableNative = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    enableSteamBeta = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    # https://reddit.com/r/linux_gaming/comments/16e1l4h/slow_steam_downloads_try_this/
    fixDownloadSpeed = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };
  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = cfg.enableNative;
      package = pkgs.steam.override {
        extraEnv = {
          MANGOHUD = true;
          OBS_VKCAPTURE = true;
          PROTON_ENABLE_WAYLAND = true;
          PROTON_ENABLE_HDR = true;
          PROTON_FSR4_UPGRADE = true;
          PROTON_USE_NTSYNC = true;
          PROTON_USE_WOW64 = true;
          PULSE_SINK = "Game";
        };
        # https://github.com/NixOS/nixpkgs/issues/279893#issuecomment-2425213386
        extraProfile = ''
          unset TZ
        '';
      };
      dedicatedServer.openFirewall = true;
      extraCompatPackages = with pkgs; [
        luxtorpeda
        inputs.chaotic.packages.${system}.proton-cachyos
        proton-ge-bin
        proton-ge-bin-fsr4
      ];
      localNetworkGameTransfers.openFirewall = true;
      protontricks.enable = true;
      remotePlay.openFirewall = true;
    };
    home-manager.users.${username} =
      { pkgs, config, ... }:
      {
        home = {
          file = {
            steam-beta = {
              enable = cfg.enableSteamBeta;
              text = "publicbeta";
              target = "${config.xdg.dataHome}/Steam/package/beta";
            };
            steam-slow-fix = {
              enable = cfg.fixDownloadSpeed;
              text = ''
                @nClientDownloadEnableHTTP2PlatformLinux 0
                @fDownloadRateImprovementToAddAnotherConnection 1.0
                unShaderBackgroundProcessingThreads 8
              '';
              target = "${config.xdg.dataHome}/Steam/steam_dev.cfg";
            };
            wine-links-protonge-fsr = {
              enable = true;
              source = config.lib.file.mkOutOfStoreSymlink "${proton-ge-bin-fsr4.steamcompattool}";
              target = "${config.xdg.dataHome}/Steam/compatibilitytools.d/GE-Proton10-bin-fsr";
            };
          };
          packages = with pkgs; [
            steamcmd
          ];
        };
        services.flatpak = lib.mkIf cfg.enableFlatpak {
          overrides = {
            "com.valvesoftware.Steam" = {
              Context = {
                filesystems = [
                  "${config.home.homeDirectory}/Games"
                  "${config.xdg.dataHome}/applications"
                  "${config.xdg.dataHome}/games"
                  "${config.xdg.dataHome}/Steam"
                ];
              };
              Environment = {
                PULSE_SINK = "Game";
              };
              "Session Bus Policy" = {
                org.freedesktop.Flatpak = "talk";
              };
            };
          };
          packages = [
            "com.valvesoftware.Steam"
          ];
        };
      };
  };
}
