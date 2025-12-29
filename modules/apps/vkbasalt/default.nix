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
        inputs,
        config,
        ...
      }:
      {
        home = {
          file = {
            vkbasalt-default-config =
              let
                reshade = "${inputs.nix-reshade.packages.${pkgs.stdenv.hostPlatform.system}.reshade-shaders}/reshade-shaders";
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
                  blending = ${reshade}/shaders/blending.fxh
                  daltonize = ${reshade}/shaders/daltonize.fx
                  deband = ${reshade}/shaders/deband.fx
                  displaydepth = ${reshade}/shaders/displaydepth.fx
                  drawtext = ${reshade}/shaders/drawtext.fxh
                  lut = ${reshade}/shaders/lut.fx
                  macros = ${reshade}/shaders/macros.fxh
                  reshade = ${reshade}/shaders/reshade.fxh
                  reshadeui = ${reshade}/shaders/reshadeui.fxh
                  tridither = ${reshade}/shaders/tridither.fxh
                  uimask = ${reshade}/shaders/uimask.fx 
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
          overrides = {
            global = {
              Context = {
                filesystems = [
                  "xdg-config/vkBasalt:ro"
                ];
              };
            };
          };
          packages = [
            "org.freedesktop.Platform.VulkanLayer.vkBasalt/x86_64/24.08"
            "org.freedesktop.Platform.VulkanLayer.vkBasalt/x86_64/25.08"
          ];
        };
      };
  };
}
