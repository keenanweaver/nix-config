{
  flake.modules.homeManager.profile-workstation =
    { pkgs, ... }:
    let
      desktopFile = "share/applications/app.fluxer.FluxerDesktopCanary.desktop";
      fluxer = pkgs.fluxer-desktop-canary;
    in
    {
      home.packages = [
        (pkgs.symlinkJoin {
          inherit (fluxer) meta name;
          nativeBuildInputs = [ pkgs.makeWrapper ];
          paths = [ fluxer ];
          postBuild = ''
            wrapProgram $out/bin/fluxer-canary --set FLUXER_DISABLE_DESKTOP_FILE 1
            rm $out/${desktopFile}
            substitute ${fluxer}/${desktopFile} $out/${desktopFile} \
              --replace-fail ${fluxer}/bin/fluxer-canary $out/bin/fluxer-canary
          '';
        })
      ];
    };
}
