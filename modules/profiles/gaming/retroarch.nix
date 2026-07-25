{
  flake.modules.homeManager.retroarch = {
    programs.retroarch = {
      cores = {
        beetle-psx-hw.enable = true;
        beetle-saturn.enable = true;
        blastem.enable = true;
        mgba.enable = true;
      };

      enable = true;

      settings = {
        video_driver = "vulkan";
        video_fullscreen = "true";
        video_smooth = "false";
      };
    };
  };
}
