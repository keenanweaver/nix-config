(final: prev: {
  fooyin = prev.callPackage ./fooyin { };
  gpu-screen-recorder = prev.callPackage ./gpu-screen-recorder/gsr.nix { };
  gpu-screen-recorder-notification = prev.callPackage ./gpu-screen-recorder/notif.nix { };
  gpu-screen-recorder-ui = prev.callPackage ./gpu-screen-recorder/ui.nix { };
  inter = prev.callPackage ./inter { };
  moondeck-buddy = prev.callPackage ./moondeck-buddy { };
  n64recomp = prev.callPackage ./zelda64recomp/n64recomp.nix { };
  nero-umu = prev.nero-umu.overrideAttrs {
    version = "1.1.5-unstable-10-13-2025";
    src = prev.fetchFromGitHub {
      owner = "SeongGino";
      repo = "Nero-umu";
      rev = "d63afb894359f421b665483eb307f089e234346f";
      hash = "sha256-Ga1FzxUZHt1t8IjUa+Ewaz2Csz+jrMIoZoL4LSwrhXQ=";
    };
  };
  nuked-sc55 = prev.callPackage ./nuked-sc55 { };
  nyan-doom = prev.callPackage ./nyan-doom { };
  openjk = prev.openjk.overrideAttrs {
    version = "0-unstable-2025-10-09";
    src = prev.fetchFromGitHub {
      owner = "JACoders";
      repo = "OpenJK";
      rev = "d1cb662f07dfa4c1999edfb5c1a86fd1c6285372";
      hash = "sha256-XTGe/V4FnQSQA9fY6MmpECs1f2PPk+yTZkAL93UoH/I=";
    };
  };
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
  proton-ge-bin = prev.proton-ge-bin.overrideAttrs (old: rec {
    version = "GE-Proton10-20";
    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-sJkaDEnfAuEqcLDBtAfU6Rny3P3lOCnG1DusWfvv2Fg=";
    };
  });
  relive = prev.callPackage ./relive { };
  rsdkv4 = prev.callPackage ./rsdkv4 { };
  scummvm = prev.scummvm.overrideAttrs {
    version = "3.0.0-unstable-10-13-2025";
    src = prev.fetchFromGitHub {
      owner = "scummvm";
      repo = "scummvm";
      rev = "217d16b9be46e9c0a32007cf7cb313f6df313100";
      hash = "sha256-qTc9TTh5VF2WxPAWwfC2vC2CZGGqnVuX19M0VjMPMdA=";
    };
  };
  tochd = prev.callPackage ./tochd { };
  uzdoom = prev.callPackage ./uzdoom { };
  xlink-kai = prev.callPackage ./xlink-kai { };
  z64decompress = prev.callPackage ./zelda64recomp/z64decompress.nix { };
  zelda64recomp = prev.callPackage ./zelda64recomp/zelda64recomp.nix { };
})
