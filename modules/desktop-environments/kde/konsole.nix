{
  flake.modules.homeManager.plasma-manager =
    {
      lib,
      pkgs,
      osConfig,
      ...
    }:
    {
      programs.konsole = {
        enable = true;
        defaultProfile = "${osConfig.my.user}";
        extraConfig = {
          KonsoleWindow.RemoveWindowTitleBarAndFrame = true;
          MainWindow.MenuBar = "Disabled";
        };
        profiles = {
          "${osConfig.my.user}".command = lib.getExe pkgs.zsh;
        };
      };
    };
}
