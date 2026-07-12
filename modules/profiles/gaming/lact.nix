{
  flake.modules.nixos.gaming-profile = {
    preservation.preserveAt."/persist".directories = [
      "/etc/lact"
    ];
    services.lact = {
      enable = true;
    };
  };
}
