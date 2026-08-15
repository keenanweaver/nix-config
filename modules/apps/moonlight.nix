{
  flake.modules.nixos.gaming-profile = { pkgs, ... }: {
    programs.moonlight-qt = {
      enable = true;
      package = pkgs.master.moonlight-qt;
      capSysNice = true;
    };
  };
}
