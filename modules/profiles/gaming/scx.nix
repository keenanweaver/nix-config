{
  flake.modules.nixos.profile-gaming = {
    # Disable password prompt
    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id.toLowerCase().indexOf("org.scx.loader") === 0 &&
            (subject.isInGroup("wheel") || subject.isInGroup("gamemode"))) {
          return polkit.Result.YES;
        }
      });
    '';
    services.scx-loader = {
      enable = true;
      config.scheds.scx_cake = {
        gaming_mode = [
          "--profile"
          "gaming"
        ];
        lowlatency_mode = [
          "--profile"
          "esports"
        ];
      };
    };
  };
}
