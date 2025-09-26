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
  prboom-plus = prev.callPackage ./prboom-plus { };
  proton-em = prev.callPackage ./proton-em { };
  /*
    proton-ge-bin = prev.proton-ge-bin.overrideAttrs (old: rec {
      version = "GE-Proton10-16";
      src = prev.fetchzip {
        url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
        hash = "sha256-pwnYnO6JPoZS8w2kge98WQcTfclrx7U2vwxGc6uj9k4=";
      };
    });
  */
  relive = prev.callPackage ./relive { };
  rsdkv4 = prev.callPackage ./rsdkv4 { };
  tochd = prev.callPackage ./tochd { };
  xlink-kai = prev.callPackage ./xlink-kai { };
  z64decompress = prev.callPackage ./zelda64recomp/z64decompress.nix { };
  zelda64recomp = prev.callPackage ./zelda64recomp/zelda64recomp.nix { };
})
