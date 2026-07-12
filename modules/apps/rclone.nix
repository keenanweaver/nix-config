{
  flake.modules.homeManager.base-profile = {
    programs.rclone = {
      enable = true;
    };
  };
}
