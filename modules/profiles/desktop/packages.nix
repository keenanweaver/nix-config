{
  flake.modules = {
    homeManager.desktop-profile = { pkgs, ... }: {
      home.packages = with pkgs; [
        gearlever
        qpwgraph
        rustdesk-flutter
      ];
    };
  };
}
