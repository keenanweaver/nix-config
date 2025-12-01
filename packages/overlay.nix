(final: prev: {
  fooyin = prev.callPackage ./fooyin { };
  gpu-screen-recorder = prev.callPackage ./gpu-screen-recorder/gsr.nix { };
  gpu-screen-recorder-notification = prev.callPackage ./gpu-screen-recorder/notif.nix { };
  gpu-screen-recorder-ui = prev.callPackage ./gpu-screen-recorder/ui.nix { };
  inter = prev.callPackage ./inter { };
  lutris-unwrapped = prev.lutris-unwrapped.overrideAttrs {
    version = "0.5.19-unstable-11-20-2025";
    src = prev.fetchFromGitHub {
      owner = "lutris";
      repo = "lutris";
      rev = "9db793dc9f3a1b2507afdce20b823801ec3b1c8e";
      hash = "sha256-QSbKHK9Nk8byZFORBjriKFijDJCJ8u1ugVcxOpxmQsk=";
    };
  };
  moondeck-buddy = prev.callPackage ./moondeck-buddy { };
  nero-umu = prev.nero-umu.overrideAttrs {
    version = "1.1.5-unstable-11-29-2025";
    src = prev.fetchFromGitHub {
      owner = "SeongGino";
      repo = "Nero-umu";
      rev = "4db5173ab37bc41d5c015ff1bdb4bf3f9a76af09";
      hash = "sha256-vITwvh2Afw3OXyiipk7KETPS5RfTbYYAWk3LhqR4nUM=";
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
  rsdkv3 = prev.callPackage ./rsdk/v3 { };
  rsdkv4 = prev.callPackage ./rsdk/v4 { };
  rsdkv5 = prev.callPackage ./rsdk/v5 { };
  scummvm = prev.scummvm.overrideAttrs {
    version = "3.0.0-unstable-11-22-2025";
    src = prev.fetchFromGitHub {
      owner = "scummvm";
      repo = "scummvm";
      rev = "0ad54bf79ef8efe3138ecaf047b00f3cb7b678e9";
      hash = "sha256-no2PvOMR2gNA7Kymn5P2JTBi0W/I1akENzJJr4L3ptc=";
    };
  };
  xlink-kai = prev.callPackage ./xlink-kai { };
  z64decompress = prev.callPackage ./zelda64recomp/z64decompress.nix { };
  zelda64recomp = prev.callPackage ./zelda64recomp/zelda64recomp.nix { };
})
