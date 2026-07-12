{
  flake.modules.homeManager.retroarch = {
    programs.retroarch = {
      enable = true;
      cores = {
        beetle-psx-hw.enable = true;
        beetle-saturn.enable = true;
        blastem.enable = true;
        mgba.enable = true;
      };
      settings = {
        video_driver = "vulkan";
        video_fullscreen = "true";
        video_smooth = "false";
      };
    };
  };
}
