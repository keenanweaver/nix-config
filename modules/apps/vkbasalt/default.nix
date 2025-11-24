{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.vkbasalt;
in
{
  options = {
    vkbasalt = {
      enable = lib.mkEnableOption "Enable vkbasalt in home-manager";
    };
  };
  config = lib.mkIf cfg.enable {
    home-manager.users.${username} =
      {
        pkgs,
        config,
        ...
      }:
      {
        home = {
          file = {
            vkbasalt-default-config =
              let
                reshade = "${pkgs.nur.repos.ataraxiasjel.reshade-shaders}/share/reshade";
              in
              {
                enable = true;
                text = ''
                  depthCapture = off
                  effects = smaa
                  enableOnLaunch = True
                  lutFile = "${reshade}/textures/lut.png"
                  reshadeTexturePath = "${reshade}/textures"
                  reshadeIncludePath = "${reshade}/shaders"
                  smaaEdgeDetection = luma
                  smaaThreshold = 0.05
                  smaaMaxSearchSteps = 32
                  smaaMaxSearchStepsDiag = 16
                  smaaCornerRounding = 25
                  toggleKey = Home
                  # ReShade effects #
                  blending = ${reshade}/shaders/Blending.fxh
                  daltonize = ${reshade}/shaders/Daltonize.fx
                  deband = ${reshade}/shaders/Deband.fx
                  displaydepth = ${reshade}/shaders/DisplayDepth.fx
                  drawtext = ${reshade}/shaders/DrawText.fxh
                  lut = ${reshade}/shaders/LUT.fx
                  macros = ${reshade}/shaders/Macros.fxh
                  reshade = ${reshade}/shaders/ReShade.fxh
                  reshadeui = ${reshade}/shaders/ReShadeUI.fxh
                  tridither = ${reshade}/shaders/TriDither.fxh
                  uimask = ${reshade}/shaders/UIMask.fx 
                '';
                target = "${config.xdg.configHome}/vkBasalt/vkBasalt.conf";
              };
          };
          packages = with pkgs; [
            vkbasalt
            vkbasalt-cli
          ];
          sessionVariables = {
            #ENABLE_VKBASALT = "1";
          };
        };
        services.flatpak = {
          packages = [
            "org.freedesktop.Platform.VulkanLayer.vkBasalt/x86_64/24.08"
            "org.freedesktop.Platform.VulkanLayer.vkBasalt/x86_64/25.08"
          ];
        };
      };
  };
}
