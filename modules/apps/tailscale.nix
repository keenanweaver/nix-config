{
  flake.modules = {
    homeManager.profile-desktop =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [ ktailctl ];
        xdg.autostart.entries = with pkgs; [
          "${ktailctl}/share/applications/org.fkoehler.KTailctl.desktop"
        ];
      };
    nixos.profile-desktop = {
      preservation.preserveAt."/persist".directories = [
        "/var/lib/tailscale"
      ];
      services.tailscale = {
        enable = true;
        extraUpFlags = [ "--accept-routes=false" ];
        openFirewall = true;
        useRoutingFeatures = "both";
      };
    };
  };
}
