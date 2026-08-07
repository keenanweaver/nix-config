{
  flake.modules.nixos.desktop-profile = {
    preservation.preserveAt."/persist".directories = [
      "/etc/mullvad-vpn"
    ];

    services.mullvad-vpn = {
      enable = true;
      gui.enable = true;
    };
  };
}
