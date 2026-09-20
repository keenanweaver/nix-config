{ lib, ... }:
{
  flake.modules.homeManager.profile-base.programs.devenv = {
    enable = lib.mkDefault true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
  };
}
