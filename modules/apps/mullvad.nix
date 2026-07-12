{
  flake.modules.nixos.desktop-profile = { pkgs, ... }: {
    services.mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
  };
}
