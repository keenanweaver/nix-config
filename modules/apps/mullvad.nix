{
  flake.modules.nixos.profile-desktop = {
    preservation.preserveAt."/persist".directories = [
      "/etc/mullvad-vpn"
    ];
    services.mullvad-vpn = {
      enable = true;
      gui.enable = true;
    };
  };
}
