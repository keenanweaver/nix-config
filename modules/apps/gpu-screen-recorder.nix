{
  flake.modules.nixos.gaming-profile = { pkgs, ... }: {
    programs.gpu-screen-recorder = {
      enable = true;
      package = pkgs.local.gpu-screen-recorder;
      ui.enable = true;
    };
  };
}
