{
  flake.modules.homeManager.base-profile = {
    programs.topgrade = {
      enable = true;
      settings = {
        commands = { };
        containers = {
          runtime = "podman";
        };
        linux = {
          "arch_package_manager" = "paru";
        };
        misc = {
          disable = [
            "clam_av_db"
            "helix"
            "home_manager"
            "nix"
            "system"
            "vim"
          ];
          "display_time" = true;
          ignore_failures = [ "powershell" ];
          no_retry = true;
          notify_each_step = true;
        };
        post_commands = { };
        pre_commands = {
          "NixOS Rebuild" = "nh os boot --update";
        };
      };
    };
  };
}
