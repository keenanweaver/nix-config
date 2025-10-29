(final: prev: {
  fooyin = prev.callPackage ./fooyin { };
  gpu-screen-recorder = prev.callPackage ./gpu-screen-recorder/gsr.nix { };
  gpu-screen-recorder-notification = prev.callPackage ./gpu-screen-recorder/notif.nix { };
  gpu-screen-recorder-ui = prev.callPackage ./gpu-screen-recorder/ui.nix { };
  inter = prev.callPackage ./inter { };
  moondeck-buddy = prev.callPackage ./moondeck-buddy { };
  n64recomp = prev.callPackage ./zelda64recomp/n64recomp.nix { };
  nero-umu = prev.nero-umu.overrideAttrs {
    version = "1.1.5-unstable-10-29-2025";
    src = prev.fetchFromGitHub {
      owner = "ern775";
      repo = "Nero-umu";
      rev = "8716b1237d86f57fbe301a78d8c06f635fb69862";
      hash = "sha256-xiBm2lgmfpN/faqnZeNtcxnIyT0iJZgrnlf3xdB2ItQ=";
    };
  };
  nuked-sc55 = prev.callPackage ./nuked-sc55 { };
  openttd = prev.openttd.overrideAttrs {
    postPatch = ''
      substituteInPlace src/music/fluidsynth.cpp \
        --replace-fail "/usr/share/soundfonts/default.sf2" \
          "${final.soundfont-generaluser}/share/soundfonts/GeneralUser-GS.sf2"
    '';
  };
  openxcom = prev.openxcom.overrideAttrs {
    pname = "openxcom-extended";
    version = "8.4.2";
    src = prev.fetchFromGitHub {
      owner = "MeridianOXC";
      repo = "OpenXcom";
      rev = "0ad66a8f0806896a1fab3747d693595c477fa820";
      hash = "sha256-QDdZKB9k7MukWUj/G/ZCPVOygRluDepx2gy9URosP9Y=";
    };
  };
  proton-em = prev.callPackage ./proton-em { };
  relive = prev.callPackage ./relive { };
  rsdkv4 = prev.callPackage ./rsdkv4 { };
  scummvm = prev.scummvm.overrideAttrs {
    version = "3.0.0-unstable-10-29-2025";
    src = prev.fetchFromGitHub {
      owner = "scummvm";
      repo = "scummvm";
      rev = "69dd0889cc9150d715b42fdaf9e3d7c6cf48e135";
      hash = "sha256-3cRdbrgxpJxtSXawxl7NQvlq/R0zrF9Y9r1yibS+blg=";
    };
  };
  tochd = prev.callPackage ./tochd { };
  xlink-kai = prev.callPackage ./xlink-kai { };
  z64decompress = prev.callPackage ./zelda64recomp/z64decompress.nix { };
  zelda64recomp = prev.callPackage ./zelda64recomp/zelda64recomp.nix { };
})
