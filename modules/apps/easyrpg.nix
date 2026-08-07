{
  flake.modules.homeManager.gaming-profile = { config, pkgs, ... }: {
    home = {
      packages = with pkgs; [
        easyrpg-player
      ];

      sessionVariables = {
        RPG2K3_RTP_PATH = "${config.home.homeDirectory}/Games/rpg-maker/RTP/2003";
        RPG2K_RTP_PATH = "${config.home.homeDirectory}/Games/rpg-maker/RTP/2000";
      };
    };
  };
}
