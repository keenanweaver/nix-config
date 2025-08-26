(final: prev: {
  fooyin = prev.callPackage ./fooyin { };
  gpu-screen-recorder = prev.callPackage ./gpu-screen-recorder/gsr.nix { };
  gpu-screen-recorder-notification = prev.callPackage ./gpu-screen-recorder/notif.nix { };
  gpu-screen-recorder-ui = prev.callPackage ./gpu-screen-recorder/ui.nix { };
  inter = prev.callPackage ./inter { };
  moondeck-buddy = prev.callPackage ./moondeck-buddy { };
  n64recomp = prev.callPackage ./zelda64recomp/n64recomp.nix { };
  nuked-sc55 = prev.callPackage ./nuked-sc55 { };
  nyan-doom = prev.callPackage ./nyan-doom { };
  /*
    proton-ge-bin = final.proton-ge-bin.overrideAttrs rec {
      pname = "GE-Proton10";
      version = "13";
      src = prev.fetchzip {
        url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${pname}-${version}/${pname}-${version}.tar.gz";
        hash = "sha256-HjCsnPX3TwUroVj8RnQ0k6unU2Ou/E5PogRIElDWjgE=";
      };
    };
  */
  relive = prev.callPackage ./relive { };
  rsdkv4 = prev.callPackage ./rsdkv4 { };
  tochd = prev.callPackage ./tochd { };
  xlink-kai = prev.callPackage ./xlink-kai { };
  z64decompress = prev.callPackage ./zelda64recomp/z64decompress.nix { };
  zelda64recomp = prev.callPackage ./zelda64recomp/zelda64recomp.nix { };
})
