{
  flake.modules.nixos.gaming-profile = {
    programs.moonlight-qt = {
      capSysNice = true;
      enable = true;
    };
  };
}
