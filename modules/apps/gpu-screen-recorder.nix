{
  flake.modules.nixos.profile-gaming = { pkgs, ... }: {
    programs.gpu-screen-recorder = {
      enable = true;
      package = pkgs.local.gpu-screen-recorder;
      ui.enable = true;
    };
  };
}
