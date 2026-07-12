{
  flake.modules.nixos.base-profile = {
    programs.gnupg.agent = {
      enable = true;
      enableBrowserSocket = true;
      enableSSHSupport = true;
    };
  };
}
