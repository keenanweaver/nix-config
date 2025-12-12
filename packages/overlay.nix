{ inputs }:

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
    version = "1.1.5-unstable-12-09-2025";
    src = prev.fetchFromGitHub {
      owner = "SeongGino";
      repo = "Nero-umu";
      rev = "53bd62fd179c04ef72ff77e3b35c0157f3804cf8";
      hash = "sha256-9g7qZOa/tTHGxAqmPRG0Jh6UeraD+9naAcEnpvDdiLc=";
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
    version = "8.4.4";
    src = prev.fetchFromGitHub {
      owner = "MeridianOXC";
      repo = "OpenXcom";
      rev = "d6eeaac0c7e10d5b85ded92a224fdc324c7f9a88";
      hash = "sha256-vppJmd+wrud9Xvx13aGM6O+YDQH5ZDxfHYTlMtAq6uE=";
    };
  };
  proton-em = final.callPackage ./proton-em { };
  proton-ge =
    inputs.nur-bandithedoge.legacyPackages.${final.stdenv.hostPlatform.system}.proton.ge.override
      {
        steamDisplayName = "GE-Proton";
      };
  relive = prev.callPackage ./relive { };
  rsdkv3 = prev.callPackage ./rsdk/v3 { };
  rsdkv4 = prev.callPackage ./rsdk/v4 { };
  rsdkv5 = prev.callPackage ./rsdk/v5 { };
  scummvm = prev.scummvm.overrideAttrs {
    version = "3.0.0-unstable-12-06-2025";
    src = prev.fetchFromGitHub {
      owner = "scummvm";
      repo = "scummvm";
      rev = "4ddb84c13352d04ab8dbeafe81f2fb6a37abc6a1";
      hash = "sha256-G2NZAEY1H49SrPjnRD4npcaWCN5L1tJWZ54y9iBSBvc=";
    };
  };
  xlink-kai = prev.callPackage ./xlink-kai { };
})
