{
  flake.modules.nixos.gaming-profile = {
    programs.moonlight-qt = {
      enable = true;
      capSysNice = true;
    };
  };
}
