(final: prev: {
  fooyin = prev.callPackage ./fooyin { };
  game-devices-udev-rules = prev.game-devices-udev-rules.overrideAttrs (oldAttrs: rec {
    version = "0.25";
    src = prev.fetchFromGitea {
      domain = "codeberg.org";
      owner = "fabiscafe";
      repo = "game-devices-udev";
      tag = version;
      hash = "sha256-CLQFdPr489OKZRj1v8EZypM1KOXgAOAOF0VQpeud4uo=";
    };
  });
  gpu-screen-recorder = prev.callPackage ./gpu-screen-recorder/gsr.nix { };
  gpu-screen-recorder-notification = prev.callPackage ./gpu-screen-recorder/notif.nix { };
  gpu-screen-recorder-ui = prev.callPackage ./gpu-screen-recorder/ui.nix { };
  inter = prev.callPackage ./inter { };
  moondeck-buddy = prev.callPackage ./moondeck-buddy { };
  n64recomp = prev.callPackage ./zelda64recomp/n64recomp.nix { };
  nero-umu = prev.nero-umu.overrideAttrs {
    version = "1.1.5-unstable-11-06-2025";
    src = prev.fetchFromGitHub {
      owner = "SeongGino";
      repo = "Nero-umu";
      rev = "f4f2774947303f2933314bf7be7f793a29f752f5";
      hash = "sha256-iurEgd5ChR+Y5/JWgnJDQNBq+BcOfUVOTafcAKVPXYI=";
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
    version = "3.0.0-unstable-11-10-2025";
    src = prev.fetchFromGitHub {
      owner = "scummvm";
      repo = "scummvm";
      rev = "5f426286b8567891381bbfd4a0dc08acbe6efad9";
      hash = "sha256-4J1z6q79RdneeU0iTT/oh6O7qUa1w8rX9rbQ2UGuu00=";
    };
  };
  tochd = prev.callPackage ./tochd { };
  xlink-kai = prev.callPackage ./xlink-kai { };
  z64decompress = prev.callPackage ./zelda64recomp/z64decompress.nix { };
  zelda64recomp = prev.callPackage ./zelda64recomp/zelda64recomp.nix { };
})
