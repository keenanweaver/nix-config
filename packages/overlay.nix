{ inputs }:

(final: prev: {
  fooyin = prev.callPackage ./fooyin { };
  gamemode = prev.gamemode.overrideAttrs {
    version = "1.8.2-unstable-09-04-2025";
    src = prev.fetchFromGitHub {
      owner = "FeralInteractive";
      repo = "gamemode";
      rev = "f0a569a5199974751a4a75ebdc41c8f0b8e4c909";
      hash = "sha256-9DB8iWiyrM4EJ94ERC5SE9acrhqeI00BF1wU0umeNFg=";
    };
  };
  gpu-screen-recorder = prev.callPackage ./gpu-screen-recorder/gsr.nix { };
  gpu-screen-recorder-notification = prev.callPackage ./gpu-screen-recorder/notif.nix { };
  gpu-screen-recorder-ui = prev.callPackage ./gpu-screen-recorder/ui.nix { };
  inter = prev.callPackage ./inter { };
  lutris-unwrapped = prev.lutris-unwrapped.overrideAttrs {
    version = "0.5.19-unstable-01-08-2026";
    src = prev.fetchFromGitHub {
      owner = "lutris";
      repo = "lutris";
      rev = "e6ce1a11e6a9f0d611eb6f91835baff9cd490f2c";
      hash = "sha256-byvUMnt3tDHoSO8cHrXb0odeZr4Je/2M8rdCvsPHFr8=";
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
    version = "8.5.1";
    src = prev.fetchFromGitHub {
      owner = "MeridianOXC";
      repo = "OpenXcom";
      rev = "8a5680904621c1c5486d546f4bd3b2c2a1ba32b2";
      hash = "sha256-7HvYYQpArZUiA+fkiyy+d5mNiozLgfu2p9t7Ob50nmE=";
    };
  };
  proton-cachyos-x86_64-v4 =
    inputs.nix-gaming-edge.packages.${final.stdenv.hostPlatform.system}.proton-cachyos-x86_64-v4;
  proton-em = final.callPackage ./proton-em { };
  proton-ge = final.proton-ge-bin.override {
    steamDisplayName = "Proton GE";
  };
  /*
    proton-ge =
     (prev.proton-ge-bin.override {
       steamDisplayName = "Proton GE";
     }).overrideAttrs
       (old: rec {
         version = "GE-Proton10-28";
         src = prev.fetchzip {
           url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
           hash = "sha256-6NvSGX8445la6WU6z9UaaKJm30eg094cuTyhHVDjbOo=";
         };
       });
  */
  relive = prev.callPackage ./relive { };
  rsdkv3 = prev.callPackage ./rsdk/v3 { };
  rsdkv4 = prev.callPackage ./rsdk/v4 { };
  scummvm = prev.scummvm.overrideAttrs {
    version = "3.0.0-unstable-01-08-2026";
    src = prev.fetchFromGitHub {
      owner = "scummvm";
      repo = "scummvm";
      rev = "5d416fc20a8e98b94539571ffaf5fcee5f45f935";
      hash = "sha256-T1/Hx6MX75pc14m0fvRS4/hrbyVbKY+3gbM+KFfH1Eo=";
    };
  };
  xlink-kai = prev.callPackage ./xlink-kai { };
})
