{
  flake.modules.homeManager.profile-desktop =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        #gearlever
        qpwgraph
        rustdesk-flutter
      ];
    };
}
