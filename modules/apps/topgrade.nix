{
  flake.modules.homeManager.base-profile = {
    programs.topgrade = {
      enable = true;
      settings = {
        containers.runtime = "podman";
        misc = {
          assume_yes = true;
          disable = [
            "claude_code"
            "helix"
            "home_manager"
            "nix"
            "vim"
            "vscodium"
          ];
          ignore_failures = [ "powershell" ];
        };
      };
    };
  };
}
