{ inputs }:

(final: prev: {
  fooyin = prev.callPackage ./fooyin { };
  gpu-screen-recorder = prev.callPackage ./gpu-screen-recorder/gsr.nix { };
  gpu-screen-recorder-notification = prev.callPackage ./gpu-screen-recorder/notif.nix { };
  gpu-screen-recorder-ui = prev.callPackage ./gpu-screen-recorder/ui.nix { };
  inter = prev.callPackage ./inter { };
  lutris-unwrapped = prev.lutris-unwrapped.overrideAttrs {
    version = "0.5.19-unstable-12-17-2025";
    src = prev.fetchFromGitHub {
      owner = "lutris";
      repo = "lutris";
      rev = "7138508851a0b103aec4354089030638af3754b8";
      hash = "sha256-bsw5KB8wFeOCKqa91QGbAI61H0pD3QOoaRBXGbCTC/E=";
    };
  };
  moondeck-buddy = prev.callPackage ./moondeck-buddy { };
  nero-umu = prev.nero-umu.overrideAttrs {
    version = "1.2.0-unstable-12-25-2025";
    src = prev.fetchFromGitHub {
      owner = "SeongGino";
      repo = "Nero-umu";
      rev = "3b225cd2bbc7bcac7b58491cbd9d139646bbe872";
      hash = "sha256-+rnWgZHBJhu90t+RSQee9bhLiUjhSAs4n8FNbhQvfiM=";
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
    version = "8.5.0";
    src = prev.fetchFromGitHub {
      owner = "MeridianOXC";
      repo = "OpenXcom";
      rev = "8d292f3b2dd5116f35d218cdd3d1fc4d754b6554";
      hash = "sha256-85sA+J+Iq5ls1f4ssTL1Xbo6uIOJIFEQ7l4rMXYNIvA=";
    };
  };
  proton-cachyos-x86_64_v4 =
    inputs.nix-gaming-edge.packages.${final.stdenv.hostPlatform.system}.proton-cachyos-x86_64_v4;
  proton-em = final.callPackage ./proton-em { };
  #proton-ge = final.proton-ge-bin;
  proton-ge = prev.proton-ge-bin.overrideAttrs (old: rec {
    version = "GE-Proton10-27";
    src = prev.fetchzip {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-yBPjPb2LzxdgEobuoeSfs3UZ1XUxZF6vIMYF+fAnLA0=";
    };
  });
  relive = prev.callPackage ./relive { };
  rsdkv3 = prev.callPackage ./rsdk/v3 { };
  rsdkv4 = prev.callPackage ./rsdk/v4 { };
  scummvm = prev.scummvm.overrideAttrs {
    version = "3.0.0-unstable-12-29-2025";
    src = prev.fetchFromGitHub {
      owner = "scummvm";
      repo = "scummvm";
      rev = "358b12ceda32ec4e7c4a01904823a595492234bd";
      hash = "sha256-cqdDJZoRY0ZN5/BCvJQHhgLWunUJYMS+P659LsB/wI0=";
    };
  };
  xlink-kai = prev.callPackage ./xlink-kai { };
})
