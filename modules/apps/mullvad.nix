{
  flake.modules.nixos.desktop-profile = {
    services.mullvad-vpn = {
      enable = true;
      gui.enable = true;
    };
  };
}
