{
  flake.modules.homeManager.base-profile = {
    programs.topgrade = {
      enable = true;
      settings = {
        containers.runtime = "podman";
        misc = {
          assume_yes = true;
          cleanup = true;
          disable = [
            "claude_code"
            "helix"
            "home_manager"
            "vim"
            "vscodium"
          ];
          ignore_failures = [ "powershell" ];
        };
      };
    };
  };
}
