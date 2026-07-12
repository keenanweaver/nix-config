{
  flake.modules = {
    homeManager.desktop-profile = { pkgs, ... }: {
      home.packages = with pkgs; [ ktailctl ];
      xdg.autostart.entries = with pkgs; [
        "${ktailctl}/share/applications/org.fkoehler.KTailctl.desktop"
      ];
    };
    nixos.desktop-profile = {
      preservation.preserveAt."/persist".directories = [
        "/var/lib/tailscale"
      ];
      services.tailscale = {
        enable = true;
        openFirewall = true;
        useRoutingFeatures = "both";
      };
    };
  };
}
